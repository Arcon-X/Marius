from __future__ import annotations

from datetime import datetime, timedelta, timezone
import os
from typing import Any

import pytest
import requests


RESULT_ACTIONS = {
    "waehlt_uns",
    "waehlt_nicht",
    "ueberlegt",
    "kein_interesse_wahl",
    "sonstige",
}
ADDRESS_FIELDS = "id,status,benutzer_id,reserviert_am,erledigt_am"


def _iso_now(offset_seconds: int = 0) -> str:
    dt = datetime.now(timezone.utc) + timedelta(seconds=offset_seconds)
    return dt.isoformat()


def _verify_tls() -> bool:
    return os.getenv("NOVUMZIV_TLS_VERIFY", "0") == "1"


def _parse_iso(ts: str | None) -> datetime:
    if not ts:
        return datetime.min.replace(tzinfo=timezone.utc)
    try:
        return datetime.fromisoformat(ts.replace("Z", "+00:00"))
    except Exception:
        return datetime.min.replace(tzinfo=timezone.utc)


def _pick_address_by_status(api_client, status: str, order: str) -> dict[str, Any]:
    res = api_client.get(
        f"/adressen?status=eq.{status}&select={ADDRESS_FIELDS}&order={order}&limit=1"
    )
    assert res.ok, f"Could not load address with status {status}: HTTP {res.status_code}"
    rows = res.json()
    assert rows, f"No address found for status={status}"
    return rows[0]


def _get_address_by_id(api_client, address_id: str) -> dict[str, Any]:
    res = api_client.get(f"/adressen?id=eq.{address_id}&select={ADDRESS_FIELDS}&limit=1")
    assert res.ok, f"Could not load fixed address {address_id}: HTTP {res.status_code}"
    rows = res.json()
    assert rows, f"Fixed address not found: {address_id}"
    return rows[0]


def _ensure_archived_address(api_client, address_restorer, fixed_address_id: str | None) -> dict[str, Any]:
    if fixed_address_id:
        addr = _get_address_by_id(api_client, fixed_address_id)
        if addr.get("status") != "archiviert":
            pytest.skip("Fixed address is not archiviert; set NOVUMZIV_TEST_ADDRESS_ID to an archiviert row")
        address_restorer(addr["id"])
        return addr

    archived = api_client.get(
        f"/adressen?status=eq.archiviert&select={ADDRESS_FIELDS}&order=erledigt_am.desc.nullslast,id.asc&limit=1"
    )
    assert archived.ok, f"Could not query archived addresses: HTTP {archived.status_code}"
    rows = archived.json()
    if rows:
        address_restorer(rows[0]["id"])
        return rows[0]

    fallback = _pick_address_by_status(api_client, "verfuegbar", "id.asc")
    address_id = fallback["id"]
    address_restorer(address_id)
    prepared = api_client.patch_json(
        f"/adressen?id=eq.{address_id}",
        {
            "status": "archiviert",
            "benutzer_id": api_client.user_id,
            "erledigt_am": _iso_now(0),
        },
    )
    assert prepared.ok, f"Could not prepare archived address: HTTP {prepared.status_code} {prepared.text}"
    return _get_address_by_id(api_client, address_id)


def _post_log(api_client, address_id: str, action: str, timestamp: str, note: str) -> requests.Response:
    payload = {
        "adressen_id": address_id,
        "benutzer_id": api_client.user_id,
        "aktion": action,
        "zeitpunkt": timestamp,
        "notiz": note,
    }
    return api_client.post_json("/protokoll", payload)


def _load_address_log(api_client, address_id: str, limit: int = 100) -> list[dict[str, Any]]:
    res = api_client.get(
        "/protokoll"
        f"?adressen_id=eq.{address_id}"
        "&select=id,adressen_id,benutzer_id,aktion,zeitpunkt,notiz"
        "&order=zeitpunkt.desc,id.desc"
        f"&limit={limit}"
    )
    assert res.ok, f"Could not load protocol rows: HTTP {res.status_code}"
    return res.json()


def _latest_active_result(log_rows: list[dict[str, Any]]) -> str | None:
    reaktiviert_at = max(
        (_parse_iso(row.get("zeitpunkt")) for row in log_rows if row.get("aktion") == "reaktiviert"),
        default=None,
    )

    candidates = []
    for row in log_rows:
        action = row.get("aktion")
        if action not in RESULT_ACTIONS:
            continue
        ts = _parse_iso(row.get("zeitpunkt"))
        if reaktiviert_at and ts <= reaktiviert_at:
            continue
        candidates.append((ts, action))

    if not candidates:
        return None
    candidates.sort(key=lambda x: x[0], reverse=True)
    return candidates[0][1]


def _events_for_run(log_rows: list[dict[str, Any]], run_id: str) -> list[dict[str, Any]]:
    marker = f"[{run_id}]"
    return [r for r in log_rows if marker in (r.get("notiz") or "")]


def test_login_rpc_success(api_base, auth_email, auth_pass, run_live):
    if not run_live:
        pytest.skip("Live backend tests disabled")
    if not auth_email or not auth_pass:
        pytest.skip("Missing credentials for live login test")
    url = f"{api_base}/rpc/login"
    res = requests.post(
        url,
        json={"email": auth_email, "passwort": auth_pass},
        timeout=20,
        verify=_verify_tls(),
    )
    if res.status_code == 429:
        pytest.skip("Login endpoint currently rate-limited (HTTP 429)")
    assert res.ok, f"Expected login success, got HTTP {res.status_code}: {res.text}"
    body = res.json()
    assert body.get("token"), "Expected token in login response"


def test_login_rpc_invalid_password(api_base, auth_email, run_live):
    if not run_live:
        pytest.skip("Live backend tests disabled")
    if not auth_email:
        pytest.skip("Missing auth email for invalid-login test")
    url = f"{api_base}/rpc/login"
    res = requests.post(
        url,
        json={"email": auth_email, "passwort": "definitely-wrong-password"},
        timeout=20,
        verify=_verify_tls(),
    )
    if res.status_code == 429:
        pytest.skip("Login endpoint currently rate-limited (HTTP 429)")
    assert not res.ok, "Invalid login should not return 2xx"


def test_claim_is_atomic_single_winner(api_client, address_restorer, fixed_address_id):
    addr = _get_address_by_id(api_client, fixed_address_id) if fixed_address_id else _pick_address_by_status(api_client, "verfuegbar", "id.asc")
    if addr.get("status") != "verfuegbar":
        pytest.skip("Fixed address is not verfuegbar; set NOVUMZIV_TEST_ADDRESS_ID to a verfuegbar row")
    address_id = addr["id"]
    address_restorer(address_id)

    claim_query = f"/adressen?id=eq.{address_id}&status=eq.verfuegbar"
    ts1 = _iso_now(1)
    ts2 = _iso_now(2)

    payload = {
        "status": "in_bearbeitung",
        "benutzer_id": api_client.user_id,
        "reserviert_am": ts1,
    }
    first = api_client.patch_json(claim_query, payload)
    assert first.ok, f"First claim failed: HTTP {first.status_code} {first.text}"
    first_rows = first.json() if first.text.strip() else []
    assert len(first_rows) == 1, "First claim should update exactly one row"

    second = api_client.patch_json(claim_query, {**payload, "reserviert_am": ts2})
    assert second.ok, f"Second claim request failed unexpectedly: HTTP {second.status_code}"
    second_rows = second.json() if second.text.strip() else []
    assert len(second_rows) == 0, "Second claim should not update any row"


def test_result_correction_latest_result_wins(api_client, address_restorer, test_run_id, created_log_ids, fixed_address_id):
    addr = _ensure_archived_address(api_client, address_restorer, fixed_address_id)
    address_id = addr["id"]

    r1 = _post_log(
        api_client,
        address_id,
        "waehlt_nicht",
        _iso_now(5),
        f"[{test_run_id}] correction step 1",
    )
    assert r1.ok, f"Could not write first result log: HTTP {r1.status_code} {r1.text}"
    created_log_ids(r1)

    r2 = _post_log(
        api_client,
        address_id,
        "waehlt_uns",
        _iso_now(6),
        f"[{test_run_id}] correction step 2",
    )
    assert r2.ok, f"Could not write corrected result log: HTTP {r2.status_code} {r2.text}"
    created_log_ids(r2)

    log_rows = _events_for_run(_load_address_log(api_client, address_id, limit=200), test_run_id)
    latest_result = _latest_active_result(log_rows)
    assert latest_result == "waehlt_uns", "Latest corrected result should be the active result"


def test_reaktiviert_invalidates_old_results(api_client, address_restorer, test_run_id, created_log_ids, fixed_address_id):
    addr = _ensure_archived_address(api_client, address_restorer, fixed_address_id)
    address_id = addr["id"]

    r1 = _post_log(
        api_client,
        address_id,
        "waehlt_uns",
        _iso_now(10),
        f"[{test_run_id}] old result",
    )
    assert r1.ok, f"Could not write result log: HTTP {r1.status_code} {r1.text}"
    created_log_ids(r1)

    r2 = _post_log(
        api_client,
        address_id,
        "reaktiviert",
        _iso_now(11),
        f"[{test_run_id}] reactivated",
    )
    assert r2.ok, f"Could not write reaktiviert log: HTTP {r2.status_code} {r2.text}"
    created_log_ids(r2)

    log_rows = _events_for_run(_load_address_log(api_client, address_id, limit=200), test_run_id)
    latest_result = _latest_active_result(log_rows)
    assert latest_result is None, "All older results must be ignored after reaktiviert"

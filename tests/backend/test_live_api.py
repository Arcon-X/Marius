from __future__ import annotations

from datetime import datetime, timedelta, timezone
from typing import Any

import requests


RESULT_ACTIONS = {
    "waehlt_uns",
    "waehlt_nicht",
    "ueberlegt",
    "kein_interesse_wahl",
    "sonstige",
}


def _iso_now(offset_seconds: int = 0) -> str:
    dt = datetime.now(timezone.utc) + timedelta(seconds=offset_seconds)
    return dt.isoformat()


def _pick_available_address(api_client) -> dict[str, Any]:
    url = (
        f"{api_client.base_url}/adressen"
        "?status=eq.verfuegbar"
        "&select=id,status,benutzer_id,reserviert_am,erledigt_am"
        "&order=id.asc&limit=1"
    )
    res = requests.get(url, headers=api_client.get_headers, timeout=20, verify=False)
    assert res.ok, f"Could not load available address: HTTP {res.status_code}"
    rows = res.json()
    assert rows, "No available address found for claim test"
    return rows[0]


def _pick_archived_address(api_client) -> dict[str, Any]:
    url = (
        f"{api_client.base_url}/adressen"
        "?status=eq.archiviert"
        "&select=id,status,benutzer_id,reserviert_am,erledigt_am"
        "&order=erledigt_am.desc.nullslast,id.asc&limit=1"
    )
    res = requests.get(url, headers=api_client.get_headers, timeout=20, verify=False)
    assert res.ok, f"Could not load archived address: HTTP {res.status_code}"
    rows = res.json()
    assert rows, "No archived address found for correction/reactivation tests"
    return rows[0]


def _post_log(api_client, address_id: str, action: str, timestamp: str, note: str) -> requests.Response:
    payload = {
        "adressen_id": address_id,
        "benutzer_id": api_client.user_id,
        "aktion": action,
        "zeitpunkt": timestamp,
        "notiz": note,
    }
    return requests.post(
        f"{api_client.base_url}/protokoll",
        headers=api_client.auth_headers,
        json=payload,
        timeout=20,
        verify=False,
    )


def _load_address_log(api_client, address_id: str, limit: int = 100) -> list[dict[str, Any]]:
    url = (
        f"{api_client.base_url}/protokoll"
        f"?adressen_id=eq.{address_id}"
        "&select=id,adressen_id,benutzer_id,aktion,zeitpunkt,notiz"
        "&order=zeitpunkt.desc"
        f"&limit={limit}"
    )
    res = requests.get(url, headers=api_client.get_headers, timeout=20, verify=False)
    assert res.ok, f"Could not load protocol rows: HTTP {res.status_code}"
    return res.json()


def _latest_active_result(log_rows: list[dict[str, Any]]) -> str | None:
    reaktiviert_at = None
    for row in log_rows:
        if row.get("aktion") == "reaktiviert":
            reaktiviert_at = row.get("zeitpunkt")
            break

    for row in log_rows:
        action = row.get("aktion")
        if action not in RESULT_ACTIONS:
            continue
        if reaktiviert_at and row.get("zeitpunkt") <= reaktiviert_at:
            continue
        return action

    return None


def test_login_rpc_success(api_base, auth_email, auth_pass, run_live):
    if not run_live:
        return
    url = f"{api_base}/rpc/login"
    res = requests.post(
        url,
        json={"email": auth_email, "passwort": auth_pass},
        timeout=20,
        verify=False,
    )
    assert res.ok, f"Expected login success, got HTTP {res.status_code}: {res.text}"
    body = res.json()
    assert body.get("token"), "Expected token in login response"


def test_login_rpc_invalid_password(api_base, auth_email, run_live):
    if not run_live:
        return
    url = f"{api_base}/rpc/login"
    res = requests.post(
        url,
        json={"email": auth_email, "passwort": "definitely-wrong-password"},
        timeout=20,
        verify=False,
    )
    assert not res.ok, "Invalid login should not return 2xx"


def test_claim_is_atomic_single_winner(api_client, address_restorer):
    addr = _pick_available_address(api_client)
    address_id = addr["id"]
    address_restorer(address_id)

    claim_url = f"{api_client.base_url}/adressen?id=eq.{address_id}&status=eq.verfuegbar"
    ts1 = _iso_now(1)
    ts2 = _iso_now(2)

    payload = {
        "status": "in_bearbeitung",
        "benutzer_id": api_client.user_id,
        "reserviert_am": ts1,
    }
    first = requests.patch(
        claim_url,
        headers=api_client.auth_headers,
        json=payload,
        timeout=20,
        verify=False,
    )
    assert first.ok, f"First claim failed: HTTP {first.status_code} {first.text}"
    first_rows = first.json() if first.text.strip() else []
    assert len(first_rows) == 1, "First claim should update exactly one row"

    second = requests.patch(
        claim_url,
        headers=api_client.auth_headers,
        json={**payload, "reserviert_am": ts2},
        timeout=20,
        verify=False,
    )
    assert second.ok, f"Second claim request failed unexpectedly: HTTP {second.status_code}"
    second_rows = second.json() if second.text.strip() else []
    assert len(second_rows) == 0, "Second claim should not update any row"


def test_result_correction_latest_result_wins(api_client, address_restorer):
    addr = _pick_archived_address(api_client)
    address_id = addr["id"]
    address_restorer(address_id)

    r1 = _post_log(api_client, address_id, "waehlt_nicht", _iso_now(5), "test correction step 1")
    assert r1.ok, f"Could not write first result log: HTTP {r1.status_code} {r1.text}"

    r2 = _post_log(api_client, address_id, "waehlt_uns", _iso_now(6), "test correction step 2")
    assert r2.ok, f"Could not write corrected result log: HTTP {r2.status_code} {r2.text}"

    log_rows = _load_address_log(api_client, address_id, limit=50)
    latest_result = _latest_active_result(log_rows)
    assert latest_result == "waehlt_uns", "Latest corrected result should be the active result"


def test_reaktiviert_invalidates_old_results(api_client, address_restorer):
    addr = _pick_archived_address(api_client)
    address_id = addr["id"]
    address_restorer(address_id)

    r1 = _post_log(api_client, address_id, "waehlt_uns", _iso_now(10), "test old result")
    assert r1.ok, f"Could not write result log: HTTP {r1.status_code} {r1.text}"

    r2 = _post_log(api_client, address_id, "reaktiviert", _iso_now(11), "test reactivated")
    assert r2.ok, f"Could not write reaktiviert log: HTTP {r2.status_code} {r2.text}"

    log_rows = _load_address_log(api_client, address_id, limit=50)
    latest_result = _latest_active_result(log_rows)
    assert latest_result is None, "All older results must be ignored after reaktiviert"

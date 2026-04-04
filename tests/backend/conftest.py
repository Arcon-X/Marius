import base64
import json
import os
import time
import uuid
from dataclasses import dataclass
from typing import Any

import pytest
import requests


DEFAULT_TIMEOUT = 20
DEFAULT_RETRIES = 4
DEFAULT_BACKOFF_SECONDS = 0.6


def _tls_verify() -> bool:
    return _env("NOVUMZIV_TLS_VERIFY", "0") == "1"


def _request_with_retry(
    method: str,
    url: str,
    *,
    headers: dict[str, str] | None = None,
    payload: dict[str, Any] | None = None,
    timeout: int = DEFAULT_TIMEOUT,
    verify_tls: bool = False,
    retries: int = DEFAULT_RETRIES,
    backoff_seconds: float = DEFAULT_BACKOFF_SECONDS,
) -> requests.Response:
    last_response = None
    for attempt in range(retries + 1):
        last_response = requests.request(
            method,
            url,
            headers=headers,
            json=payload,
            timeout=timeout,
            verify=verify_tls,
        )
        if last_response.status_code not in (429, 502, 503, 504):
            return last_response
        if attempt >= retries:
            return last_response
        retry_after = last_response.headers.get("Retry-After")
        if retry_after and retry_after.isdigit():
            wait_s = float(retry_after)
        else:
            wait_s = backoff_seconds * (2 ** attempt)
        time.sleep(wait_s)
    return last_response


@dataclass
class ApiClient:
    base_url: str
    token: str
    user_id: str | None
    timeout: int = DEFAULT_TIMEOUT
    verify_tls: bool = False
    retries: int = DEFAULT_RETRIES
    backoff_seconds: float = DEFAULT_BACKOFF_SECONDS

    @property
    def auth_headers(self) -> dict[str, str]:
        return {
            "Authorization": f"Bearer {self.token}",
            "Content-Type": "application/json",
            "Prefer": "return=representation",
        }

    @property
    def get_headers(self) -> dict[str, str]:
        return {"Authorization": f"Bearer {self.token}"}

    def _request(self, method: str, path_with_query: str, payload: dict[str, Any] | None = None) -> requests.Response:
        url = f"{self.base_url}{path_with_query}"
        last_response = None
        for attempt in range(self.retries + 1):
            last_response = requests.request(
                method,
                url,
                headers=self.auth_headers if method != "GET" else self.get_headers,
                json=payload,
                timeout=self.timeout,
                verify=self.verify_tls,
            )
            if last_response.status_code not in (429, 502, 503, 504):
                return last_response
            if attempt >= self.retries:
                return last_response
            retry_after = last_response.headers.get("Retry-After")
            if retry_after and retry_after.isdigit():
                wait_s = float(retry_after)
            else:
                wait_s = self.backoff_seconds * (2 ** attempt)
            time.sleep(wait_s)
        return last_response

    def get(self, path_with_query: str) -> requests.Response:
        return self._request("GET", path_with_query)

    def post_json(self, path: str, payload: dict[str, Any]) -> requests.Response:
        return self._request("POST", path, payload)

    def patch_json(self, path_with_query: str, payload: dict[str, Any]) -> requests.Response:
        return self._request("PATCH", path_with_query, payload)

    def delete(self, path_with_query: str) -> requests.Response:
        return self._request("DELETE", path_with_query)


def _decode_user_id(token: str) -> str | None:
    try:
        payload_b64 = token.split(".")[1]
        payload_b64 += "=" * ((4 - len(payload_b64) % 4) % 4)
        payload = json.loads(base64.urlsafe_b64decode(payload_b64.encode("utf-8")).decode("utf-8"))
        return payload.get("user_id")
    except Exception:
        return None


def _env(name: str, default: str | None = None) -> str | None:
    value = os.getenv(name, default)
    if value is None:
        return None
    return value.strip()


@pytest.fixture(scope="session")
def run_live() -> bool:
    return _env("RUN_BACKEND_LIVE_TESTS", "0") == "1"


@pytest.fixture(scope="session")
def api_base() -> str:
    return _env("NOVUMZIV_API", "https://204.168.217.211.nip.io/api")


@pytest.fixture(scope="session")
def auth_email() -> str | None:
    return _env("NOVUMZIV_EMAIL") or _env("LOGIN_EMAIL")


@pytest.fixture(scope="session")
def auth_pass() -> str | None:
    return _env("NOVUMZIV_PASS") or _env("LOGIN_PASS")


@pytest.fixture(scope="session")
def api_client(run_live: bool, api_base: str, auth_email: str | None, auth_pass: str | None) -> ApiClient:
    if not run_live:
        pytest.skip("Live backend tests are disabled. Set RUN_BACKEND_LIVE_TESTS=1 to enable.")
    if not auth_email or not auth_pass:
        pytest.skip("Missing credentials. Set NOVUMZIV_EMAIL and NOVUMZIV_PASS.")

    login_url = f"{api_base}/rpc/login"
    retries = int(_env("NOVUMZIV_HTTP_RETRIES", str(DEFAULT_RETRIES)) or DEFAULT_RETRIES)
    backoff = float(_env("NOVUMZIV_HTTP_BACKOFF", str(DEFAULT_BACKOFF_SECONDS)) or DEFAULT_BACKOFF_SECONDS)
    res = _request_with_retry(
        "POST",
        login_url,
        payload={"email": auth_email, "passwort": auth_pass},
        timeout=DEFAULT_TIMEOUT,
        verify_tls=_tls_verify(),
        retries=retries,
        backoff_seconds=backoff,
    )
    if res.status_code == 429:
        pytest.skip("Live backend is rate-limited (HTTP 429) - skipping stateful suite.")
    assert res.ok, f"Login failed: HTTP {res.status_code} - {res.text}"
    token = res.json().get("token")
    assert token, "No token returned from login endpoint"

    return ApiClient(
        base_url=api_base,
        token=token,
        user_id=_decode_user_id(token),
        timeout=DEFAULT_TIMEOUT,
        verify_tls=_tls_verify(),
        retries=retries,
        backoff_seconds=backoff,
    )


@pytest.fixture(scope="session")
def test_run_id() -> str:
    # Eindeutiger Prefix, um Testdatensaetze in Logs pro Lauf zu isolieren.
    return f"live-{uuid.uuid4().hex[:12]}"


@pytest.fixture(scope="session")
def fixed_address_id() -> str | None:
    # Optional: fixe Testadresse fuer reproduzierbare Staging-Laeufe.
    return _env("NOVUMZIV_TEST_ADDRESS_ID")


@pytest.fixture()
def address_restorer(api_client: ApiClient):
    original: dict[str, Any] | None = None

    def capture(address_id: str) -> dict[str, Any]:
        nonlocal original
        res = api_client.get(
            f"/adressen?id=eq.{address_id}&select=id,status,benutzer_id,reserviert_am,erledigt_am"
        )
        assert res.ok, f"Could not capture original address state: {res.status_code}"
        rows = res.json()
        assert rows, f"Address not found: {address_id}"
        original = rows[0]
        return original

    yield capture

    if not original:
        return

    payload = {
        "status": original.get("status"),
        "benutzer_id": original.get("benutzer_id"),
        "reserviert_am": original.get("reserviert_am"),
        "erledigt_am": original.get("erledigt_am"),
    }
    api_client.patch_json(f"/adressen?id=eq.{original['id']}", payload)


@pytest.fixture()
def created_log_ids(api_client: ApiClient):
    ids: list[str] = []

    def register(response: requests.Response):
        if not response.ok:
            return
        try:
            body = response.json()
        except Exception:
            return
        if isinstance(body, dict):
            row_id = body.get("id")
            if row_id:
                ids.append(row_id)
            return
        if isinstance(body, list):
            for row in body:
                if isinstance(row, dict) and row.get("id"):
                    ids.append(row["id"])

    yield register

    for log_id in ids:
        # Best effort cleanup; depending on DB policies DELETE may be denied.
        api_client.delete(f"/protokoll?id=eq.{log_id}")

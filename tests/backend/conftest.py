import base64
import json
import os
from dataclasses import dataclass
from typing import Any

import pytest
import requests


@dataclass
class ApiClient:
    base_url: str
    token: str
    user_id: str | None

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
    res = requests.post(
        login_url,
        json={"email": auth_email, "passwort": auth_pass},
        timeout=20,
        verify=False,
    )
    assert res.ok, f"Login failed: HTTP {res.status_code} - {res.text}"
    token = res.json().get("token")
    assert token, "No token returned from login endpoint"

    return ApiClient(base_url=api_base, token=token, user_id=_decode_user_id(token))


@pytest.fixture()
def address_restorer(api_client: ApiClient):
    original: dict[str, Any] | None = None

    def capture(address_id: str) -> dict[str, Any]:
        nonlocal original
        url = (
            f"{api_client.base_url}/adressen"
            f"?id=eq.{address_id}&select=id,status,benutzer_id,reserviert_am,erledigt_am"
        )
        res = requests.get(url, headers=api_client.get_headers, timeout=20, verify=False)
        assert res.ok, f"Could not capture original address state: {res.status_code}"
        rows = res.json()
        assert rows, f"Address not found: {address_id}"
        original = rows[0]
        return original

    yield capture

    if not original:
        return

    patch_url = f"{api_client.base_url}/adressen?id=eq.{original['id']}"
    payload = {
        "status": original.get("status"),
        "benutzer_id": original.get("benutzer_id"),
        "reserviert_am": original.get("reserviert_am"),
        "erledigt_am": original.get("erledigt_am"),
    }
    requests.patch(
        patch_url,
        headers=api_client.auth_headers,
        json=payload,
        timeout=20,
        verify=False,
    )

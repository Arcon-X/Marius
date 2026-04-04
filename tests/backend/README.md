Backend tests (live API)

Purpose
- Validate critical API behavior against a running NOVUM-ZIV backend.
- Keep tests opt-in to avoid accidental writes to production.

Included tests
- Login success and invalid-password rejection
- Atomic claim behavior (single winner)
- Result correction behavior (latest result is active)
- Reactivation behavior (older results invalidated)

Safety model
- Live tests run only if RUN_BACKEND_LIVE_TESTS=1
- Credentials must be provided via env vars
- Address status fields are restored after each stateful test
- Created protocol rows are tracked and deleted in teardown (best effort; policy dependent)

Environment variables
- RUN_BACKEND_LIVE_TESTS=1
- NOVUMZIV_API=https://204.168.217.211.nip.io/api (optional, default set)
- NOVUMZIV_EMAIL=...
- NOVUMZIV_PASS=...
- NOVUMZIV_TLS_VERIFY=1 (recommended/default for CI; set to 0 only for self-signed/dev endpoints)
- NOVUMZIV_TEST_ADDRESS_ID=... (optional fixed address for deterministic staging runs)
- NOVUMZIV_HTTP_RETRIES=4 (default)
- NOVUMZIV_HTTP_BACKOFF=0.6 (seconds, exponential backoff base)

Install
- pip install -r tests/backend/requirements.txt

Run
- pytest tests/backend -q

Recommended usage
- Run against staging first
- Run with dedicated test user credentials

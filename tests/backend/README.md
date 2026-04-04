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
- Protocol rows created by tests are intentionally append-only and not auto-deleted

Environment variables
- RUN_BACKEND_LIVE_TESTS=1
- NOVUMZIV_API=https://204.168.217.211.nip.io/api (optional, default set)
- NOVUMZIV_EMAIL=...
- NOVUMZIV_PASS=...

Install
- pip install -r tests/backend/requirements.txt

Run
- pytest tests/backend -q

Recommended usage
- Run against staging first
- Run with dedicated test user credentials

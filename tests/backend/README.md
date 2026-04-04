---
title: "NOVUM-ZIV — Backend-Testdokumentation"
---

<style>
.doc-nav { position: sticky; top: .5rem; z-index: 20; background: #fff; border: 1px solid #d0d7de; border-radius: 10px; padding: .7rem; margin: .2rem 0 1rem 0; box-shadow: 0 2px 8px rgba(0,0,0,.05); }
.doc-nav-title { font-size: .8rem; color: #57606a; font-weight: 700; margin-bottom: .45rem; }
.doc-nav-links { display: flex; gap: .4rem; overflow-x: auto; padding-bottom: .15rem; }
.doc-nav-links a { text-decoration: none; border: 1px solid #d0d7de; background: #f6f8fa; color: #24292f; border-radius: 999px; padding: .32rem .72rem; white-space: nowrap; font-size: .82rem; font-weight: 600; }
.doc-nav-links a.active { background: #1f6feb; border-color: #1f6feb; color: #fff; }
</style>

<div class="doc-nav" role="navigation" aria-label="Dokumentationsnavigation">
	<div class="doc-nav-title">Dokumentation</div>
	<div class="doc-nav-links">
		<a href="/docs/index.html">Hub</a>
		<a href="/docs/import_report.html">Import</a>
		<a href="/docs/features.html">Features</a>
		<a href="/docs/technik.html">Technik</a>
		<a href="/docs/db_model.html">DB</a>
		<a href="/SPEC.html">SPEC</a>
		<a href="/docs/domain.html">Domain</a>
		<a href="/docs/tests_businesscases.html">Tests BC</a>
		<a href="/tests/backend/README.html" class="active">Tests Backend</a>
	</div>
</div>

# Backend tests (live API)

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

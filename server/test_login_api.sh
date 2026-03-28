#!/bin/bash
# Quick test of login endpoint
curl -sk -X POST http://127.0.0.1:3000/rpc/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","passwort":"wrongpw"}' \
  -w '\nHTTP_CODE: %{http_code}\n'

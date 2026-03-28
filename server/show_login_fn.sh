#!/bin/bash
sudo -u postgres psql -d novumziv -t -c "SELECT prosrc FROM pg_proc WHERE proname='login' AND pronamespace=(SELECT oid FROM pg_namespace WHERE nspname='api');"

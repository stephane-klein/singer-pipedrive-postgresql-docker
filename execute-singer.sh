#!/usr/bin/env bash
set -e

echo "$(date "+%Y-%m-%d %H:%M:%S") Import pipedrive starting..."

if [ -f "/states/state.json" ]; then 
    /src/.venv/tap-pipedrive/bin/tap-pipedrive \
        -c /tap-pipedrive-config.json \
        -s /states/state.json \
        --catalog /pipedrive-catalog.json \
        | /src/.venv/target-postgres/bin/target-postgres \
        --config /target_postgres_config.json \
        > /states/state-target.json
else
    /src/.venv/tap-pipedrive/bin/tap-pipedrive \
        -c /tap-pipedrive-config.json \
        --catalog /pipedrive-catalog.json \
        | /src/.venv/target-postgres/bin/target-postgres \
        --config /target_postgres_config.json \
        > /states/state-target.json
fi

tail -1 /states/state-target.json > /states/state.json

echo "$(date "+%Y-%m-%d %H:%M:%S") Import pipedrive done"
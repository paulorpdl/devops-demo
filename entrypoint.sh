#!/usr/bin/env bash

set -e

# Detecting available cores
CPU_CORES=$(nproc)

: "${APP_MODULE:=demo.asgi}"
: "${WORKERS:=$(( 2 * CPU_CORES + 1))}"
: "${THREADS:=2}"
: "${BIND:=0.0.0.0:8000}"
: "${TIMEOUT:=60}"
: "${LOG_LEVEL:=info}"

python manage.py migrate --noinput

# Start Gunicorn
python -m gunicorn "$APP_MODULE" \
        --workers "$WORKERS" \
        --threads "$THREADS" \
        --worker-class uvicorn.workers.UvicornWorker \
        --bind "$BIND" \
        --timeout "$TIMEOUT" \
        --log-level "$LOG_LEVEL" \
        --access-logfile "-" \
        --error-logfile "-"
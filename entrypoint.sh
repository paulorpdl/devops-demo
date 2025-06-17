#!/usr/bin/env bash

set -e

# Default values
: "${APP_MODULE:=demo.asgi}"
: "${BIND:=0.0.0.0:8000}"
: "${GUNICORN_WORKERS_PER_CORE:=2}"
: "${GUNICORN_MAX_WORKERS:=16}"  # 0 = sin tope
: "${TIMEOUT:=60}"
: "${LOG_LEVEL:=info}"
: "${RUN_MIGRATIONS:=true}"
: "${RUN_COLLECTSTATIC:=true}"

# Detect available cores from CGroup in Kubernetes (if enabled)
get_cpu_limit() {
  if [ -f /sys/fs/cgroup/cpu/cpu.cfs_quota_us ] && [ -f /sys/fs/cgroup/cpu/cpu.cfs_period_us ]; then
    quota=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
    period=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)

    if [ "$quota" -gt 0 ] && [ "$period" -gt 0 ]; then
      echo $((quota / period))
      return
    fi
  fi
  nproc
}

# Calculate WORKERS for gunicorn
CPU_CORES=$(get_cpu_limit)
WORKERS=$(awk "BEGIN { w = int($CPU_CORES * $GUNICORN_WORKERS_PER_CORE); print (w < 1 ? 1 : w) }")
if [ "$GUNICORN_MAX_WORKERS" -gt 0 ] && [ "$WORKERS" -gt "$GUNICORN_MAX_WORKERS" ]; then
  WORKERS=$GUNICORN_MAX_WORKERS
fi

# Run database migration
if [ "$RUN_MIGRATIONS" = "true" ]; then
  python manage.py migrate --noinput
fi

# Start Gunicorn
exec gunicorn "$APP_MODULE" \
        --worker-class uvicorn.workers.UvicornWorker \
        --workers $WORKERS \
        --bind "$BIND" \
        --timeout "$TIMEOUT" \
        --log-level "$LOG_LEVEL" \
        --access-logfile "-" \
        --error-logfile "-" 
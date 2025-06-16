#!/usr/bin/env bash

python manage.py migrate --noinput

# Start Gunicorn
python -m gunicorn --bind 0.0.0.0:8000 --workers 3 demo.wsgi
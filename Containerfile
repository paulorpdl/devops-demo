FROM python:3.11.3-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN pip install --upgrade pip \
    && useradd -m app

# Copy source code
COPY --chown=app:app . /app

# Switch to app user and home directory
USER 1000
WORKDIR /app

# Build dependencies
RUN pip install -r requirements.txt \
    && chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/app/entrypoint.sh" ]
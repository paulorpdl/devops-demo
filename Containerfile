FROM python:3.11.3-slim

LABEL org.opencontainers.image.description "DevOps skills demonstration with Python, Containers & Kubernetes"

RUN pip install --upgrade pip \
    && useradd -m app

# Copy source code
COPY --chown=app:app . /app

# Switch to app user and home directory
USER 1000
WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="$PATH:/home/app/.local/bin"

# Build dependencies
RUN pip install -r requirements.txt \
    && chmod +x /app/entrypoint.sh

EXPOSE 8000

ENTRYPOINT [ "/app/entrypoint.sh" ]
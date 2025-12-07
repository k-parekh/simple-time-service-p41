##############################
# Stage 1 — Build Environment
##############################
FROM python:3.11-slim AS builder

# Prevents Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
# Ensures Python output is flushed
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system build dependencies only for compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install dependencies to a temporary directory
RUN pip install --user --no-cache-dir -r requirements.txt


##############################
# Stage 2 — Runtime Environment
##############################
FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m appuser
USER appuser

# Copy installed site-packages from builder image
COPY --from=builder /root/.local /home/appuser/.local

ENV PATH=/home/appuser/.local/bin:$PATH

# Copy application code
COPY --chown=appuser:appuser . .

# Expose Application port
EXPOSE 8080

########################################
# Healthcheck (Prevents restarting loops)
########################################
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD curl --fail http://localhost:8000/health || exit 1

############################################
# Gunicorn with Uvicorn Workers (Production)
############################################
CMD ["gunicorn", "simple_time_service:app", \
     "--workers", "4", \
     "--worker-class", "uvicorn.workers.UvicornWorker", \
     "--bind", "0.0.0.0:8080", \
     "--timeout", "120"]

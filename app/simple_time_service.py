"""
SimpleTimeService - FastAPI Version
-----------------------------------
A production-friendly microservice that returns:
- Current UTC timestamp (ISO 8601)
- Visitor's IP address

Includes:
- FastAPI for high performance
- JSON-based logging for observability
- Clean, modular structure
"""

from fastapi import FastAPI, Request, Response
from fastapi.responses import JSONResponse
import datetime
import logging
from pythonjsonlogger import jsonlogger

# ---------------------------------------------------------------------
# Configure JSON Logging (Best Practice for Microservices)
# ---------------------------------------------------------------------

logger = logging.getLogger()
logger.setLevel(logging.INFO)

log_handler = logging.StreamHandler()
log_format = jsonlogger.JsonFormatter(
    "%(asctime)s %(levelname)s %(message)s"
)
log_handler.setFormatter(log_format)

logger.handlers = [log_handler]

# ---------------------------------------------------------------------
# FastAPI Application
# ---------------------------------------------------------------------

app = FastAPI(title="SimpleTimeService", version="2.0")

# ---------------------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------------------

def get_client_ip(request: Request) -> str:
    """
    Extract the client IP address.
    Supports direct and proxied requests.
    """
    x_forwarded_for = request.headers.get("X-Forwarded-For")
    if x_forwarded_for:
        return x_forwarded_for.split(",")[0].strip()

    return request.client.host


def get_current_timestamp() -> str:
    """
    Get current timestamp in ISO 8601 UTC format.
    """
    return str(datetime.datetime.now(datetime.timezone.utc).isoformat().replace("+00:00", "Z"))


# ---------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------

@app.get("/", response_class=JSONResponse, tags=["Root"])
async def root_handler(request: Request):
    """
    Root endpoint returning timestamp and client IP.
    """
    timestamp = get_current_timestamp()
    client_ip = get_client_ip(request)

    logging.info(
        "Request served",
        extra={
            "client_ip": client_ip,
            "request_timestamp": timestamp,
            "request_path": str(request.url)
        }
    )

    return {
        "timestamp": timestamp,
        "ip": client_ip
    }


# Added the following app.get to reduce log noise.

@app.get("/favicon.ico")
async def favicon():
    return Response(content=None, status_code=204)  # No Content


@app.get("/health")
def health():
    return {"status": "ok"}
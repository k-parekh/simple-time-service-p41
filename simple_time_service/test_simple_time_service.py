"""
Unit tests for SimpleTimeService (FastAPI)
"""

from fastapi.testclient import TestClient
from simple_time_service import app
import re

client = TestClient(app)

def test_root_status_code():
    """Ensure / returns HTTP 200."""
    response = client.get("/")
    assert response.status_code == 200

def test_root_json_structure():
    """Ensure JSON contains timestamp + ip."""
    response = client.get("/")
    json_data = response.json()

    assert "timestamp" in json_data
    assert "ip" in json_data

def test_timestamp_format():
    """Validate timestamp is in ISO 8601 UTC format."""
    response = client.get("/")
    timestamp = response.json()["timestamp"]

    iso8601_regex = r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.*Z"
    assert re.match(iso8601_regex, timestamp)

def test_ip_value():
    """Ensure returned IP is not blank."""
    response = client.get("/")
    ip = response.json()["ip"]

    assert isinstance(ip, str)
    assert len(ip) > 0

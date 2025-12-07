# SimpleTimeService

**SimpleTimeService** is a lightweight FastAPI microservice that returns the current timestamp and the IP address of the client making the request. The service responds in **JSON format** and is containerized for easy deployment with Docker.

---

## **Features**

- Returns current UTC timestamp and client IP
- Structured JSON logging for observability
- Lightweight and production-ready using FastAPI + Uvicorn + Gunicorn
- Healthcheck endpoint `/health`
- Favicon endpoint `/favicon.ico` (returns 204 No Content)
- Fully containerized for Docker environments
- Includes unit tests for core functionality

---

## **Prerequisites**

Before you start, make sure you have:

- **Python 3.11** installed
- **pip** (Python package manager)
- **Docker** installed (for containerized deployment)
- **Git** (optional, if cloning the repository)

---

## **Project Structure**

```
app/
├── Dockerfile
├── requirements.txt
├── simple_time_service.py
├── test_simple_time_service.py
└── README.md
```

---

## **1️⃣ Running Standalone Application**

1. *Create a virtual environment (optional but recommended)*

    ```bash
    python -m venv venv
    ```

2. *Activate the virtual environment*

    On Windows:
    ```bash
    venv\Scripts\activate
    ```

    On macOS/Linux:
    ```bash
    source venv/bin/activate
    ```

3. *Install dependencies*
    ```bash
    pip install -r requirements.txt
    ```

4. *Run the application*
    ```bash
    uvicorn simple_time_service:app --host 0.0.0.0 --port 8080
    ```

5. *Access the service*

    Open a browser or use curl:

    http://127.0.0.1:8080/


    Example response:
    ```json
    {
    "timestamp": "2025-12-07T17:29:41.524513Z",
    "ip": "127.0.0.1"
    }
    ```


## **2️⃣ Running Unit Tests**

The project uses pytest for testing.

Make sure dependencies are installed (see above)

- *Run the tests:*
    ```bash
    pytest
    ```

    All tests should pass

    Sample output:
    ```
    4 passed, 0 failed
    ```

## **3️⃣ Running the Application with Docker Compose**

- *Build and start the service with a single command:*
    ```bash
    docker-compose up --build -d
    ```

    Access the endpoints:

    http://localhost:8080/


- *View logs:*
    ```bash
    docker-compose logs -f
    ```

- *Stop the service:*
    ```bash
    docker-compose down
    ```

## **4️⃣ Notes for Beginners**

- `Virtual environment`: Keeps project dependencies separate from system Python
- `Uvicorn`: ASGI server used for local development
- `Gunicorn`: Production-grade server, used inside Docker
- `JSON logging`: Makes it easy to track requests in structured logs

## **5️⃣ Quick Commands Summary**

| Action | Command |
| --- | --- |
| Create virtualenv | `python -m venv venv` |
| Activate virtualenv | `source venv/bin/activate (Linux/macOS) or venv\Scripts\activate (Windows)` |
| Install dependencies | `pip install -r requirements.txt` |
| Run standalone app | `uvicorn simple_time_service:app --host 0.0.0.0 --port 8080` |
| Run tests | `pytest` |
| Build & run Docker Compose | `docker-compose up --build -d` |
| View logs | `docker-compose logs -f` |
| Stop Docker Compose | `docker-compose down` |
| Build Docker image manually | `docker build -t simple-time-service .` |
| Run Docker container manually | `docker run -d -p 8080:8080 simple-time-service` |

## **6️⃣ Additional Endpoints**

| Endpoint | Description |
| --- | --- |
| / | Returns current timestamp & IP |
| /favicon.ico | Returns 204 No Content |
| /health | Returns service status ({"status":"ok"}) |

## **7️⃣ Contact / Support**

If you face any issues, please check:

- Python & pip versions
- Docker installation
- Logs inside Docker (docker logs <container_id>)

You can reach out to the author for help or suggestions.

Enjoy using SimpleTimeService!

---
@echo off
:: Check if Docker is installed
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Docker is not installed. Please install Docker Desktop for Windows.
    exit /b 1
)

:: Check if Docker Compose is installed (Docker Desktop includes Compose v2)
docker compose version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Docker Compose is not installed. Please install Docker Compose v2 with Docker Desktop.
    exit /b 1
)

:: Create Docker volumes
docker volume create timescale-db-data
docker volume create mosquitto-data
docker volume create mosquitto-config
docker volume create mosquitto-log
docker volume create coolview-server-certificates
docker volume create coolview-server-logs
docker volume create coolview-client-certbot
docker volume create coolview-client-nginx-certificates
docker volume create coolview-client-nginx-logs

echo Docker volumes created successfully.

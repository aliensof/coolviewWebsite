#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
  echo "Docker is not installed. Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker "$USER"
  echo "Docker installed successfully."
fi

# Check if Docker Compose is installed
if ! command_exists docker-compose; then
  echo "Docker Compose is not installed. Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "Docker Compose installed successfully."
fi

docker volume create timescale-db-data
docker volume create mosquitto-data
docker volume create mosquitto-config
docker volume create mosquitto-log
docker volume create coolview-server-certificates
docker volume create coolview-server-logs
docker volume create coolview-client-certbot
docker volume create coolview-client-nginx-certificates
docker volume create coolview-client-nginx-logs
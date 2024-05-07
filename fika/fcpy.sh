#!/bin/bash
echo "Starting FIKA Docker environment..."

# Check if necessary directory is ready
if [ ! -d "/fika/build" ]; then
    echo "Server directory not found!"
    exit 1
fi

# Change directory to server
cd /fika/build

# Modify configuration to allow connections from any IP
if [ -f "Aki_Data/Server/configs/http.json" ]; then
    sed -i 's/127.0.0.1/0.0.0.0/g' Aki_Data/Server/configs/http.json
else
    echo "Configuration file not found, check your Docker setup."
    exit 1
fi

# Execute the server application
if [ -f "./Aki.Server.exe" ]; then
    echo "Starting the server..."
    ./Aki.Server.exe
else
    echo "Server executable not found, check your Docker setup."
    exit 1
fi

echo "Server started successfully."
exit 0

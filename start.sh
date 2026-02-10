#!/bin/bash
# Start script for OneOCR server in Docker container
# This script handles Xvfb (virtual display) initialization and graceful shutdown

set -e

echo "Starting OneOCR Server in Wine environment..."

# Start Xvfb (X Virtual Frame Buffer) in the background
echo "Initializing virtual display (Xvfb)..."
Xvfb :0 -screen 0 1024x768x16 &
XVFB_PID=$!

# Wait for Xvfb to initialize
sleep 2

# Function to handle shutdown
cleanup() {
    echo "Shutting down OneOCR server..."
    kill $XVFB_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Start the OneOCR server
echo "Starting OneOCR API server on port 8001..."
python3 -m oneocr &
SERVER_PID=$!

# Wait for the server process
wait $SERVER_PID

#!/bin/bash
# Test script for OneOCR Docker deployment
# This script helps verify the Docker container is working correctly

set -e

CONTAINER_NAME="oneocr-server"
API_URL="http://localhost:8001"

echo "==================================="
echo "OneOCR Docker Test Script"
echo "==================================="
echo ""

# Check if Docker is running
echo "1. Checking Docker..."
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running or not installed"
    exit 1
fi
echo "✅ Docker is running"
echo ""

# Check if container exists
echo "2. Checking if container exists..."
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "✅ Container '${CONTAINER_NAME}' exists"
    
    # Check if container is running
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo "✅ Container is running"
    else
        echo "⚠️  Container exists but is not running"
        echo "   Starting container..."
        docker start ${CONTAINER_NAME}
        echo "   Waiting for container to initialize (30 seconds)..."
        sleep 30
    fi
else
    echo "❌ Error: Container '${CONTAINER_NAME}' not found"
    echo "   Please run: docker-compose up -d"
    exit 1
fi
echo ""

# Check if DLL files are mounted
echo "3. Checking DLL files..."
if docker exec ${CONTAINER_NAME} test -f /root/.config/oneocr/oneocr.dll; then
    echo "✅ oneocr.dll found"
else
    echo "❌ Error: oneocr.dll not found in container"
    echo "   Make sure you have created oneocr_files/ directory with the required DLLs"
    exit 1
fi

if docker exec ${CONTAINER_NAME} test -f /root/.config/oneocr/oneocr.onemodel; then
    echo "✅ oneocr.onemodel found"
else
    echo "❌ Error: oneocr.onemodel not found in container"
    exit 1
fi

if docker exec ${CONTAINER_NAME} test -f /root/.config/oneocr/onnxruntime.dll; then
    echo "✅ onnxruntime.dll found"
else
    echo "❌ Error: onnxruntime.dll not found in container"
    exit 1
fi
echo ""

# Check if API is responding
echo "4. Testing API endpoint..."
if command -v curl > /dev/null 2>&1; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" ${API_URL}/ || echo "000")
    if [ "$HTTP_CODE" != "000" ]; then
        echo "✅ API is responding (HTTP ${HTTP_CODE})"
    else
        echo "❌ Error: Cannot connect to API at ${API_URL}"
        echo "   Check if the server is running: docker logs ${CONTAINER_NAME}"
        exit 1
    fi
else
    echo "⚠️  curl not found, skipping API test"
fi
echo ""

# Display container logs
echo "5. Recent container logs:"
echo "-----------------------------------"
docker logs --tail 20 ${CONTAINER_NAME}
echo "-----------------------------------"
echo ""

echo "==================================="
echo "✅ All checks passed!"
echo "==================================="
echo ""
echo "Next steps:"
echo "1. Test with an image:"
echo "   curl -X POST --data-binary \"@your-image.jpg\" ${API_URL}/"
echo ""
echo "2. View full logs:"
echo "   docker logs -f ${CONTAINER_NAME}"
echo ""
echo "3. Stop the container:"
echo "   docker-compose down"
echo ""

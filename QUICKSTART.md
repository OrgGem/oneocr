# Quick Start Guide - OneOCR Linux Container

## TL;DR / Tóm tắt

```bash
# 1. Get DLL files from Windows 11 Snipping Tool
# 2. Place them in oneocr_files/ directory
mkdir -p oneocr_files

# 3. Build and run
docker-compose up -d

# 4. Test
curl -X POST --data-binary "@test.jpg" http://localhost:8001/
```

## Prerequisites / Yêu cầu

- Docker & Docker Compose installed / đã cài đặt
- DLL files from Windows 11 Snipping Tool / File DLL từ Snipping Tool Windows 11

## Step-by-Step / Từng bước

### 1. Get Required DLL Files / Lấy các file DLL cần thiết

**Option A: From Windows Machine / Từ máy Windows**

If you have Windows 11 with Snipping Tool installed:
```bash
# DLL files are typically in:
C:\Program Files\WindowsApps\Microsoft.ScreenSketch_*\SnippingTool\
```

**Option B: Download from Microsoft Store / Tải từ Microsoft Store**

1. Go to / Truy cập: https://store.rg-adguard.net
2. Enter URL: `https://apps.microsoft.com/detail/9mz95kl8mr0l`
3. Select "Slow" and download the latest `.msixbundle`
4. Rename to `.zip` and extract
5. Find `SnippingToolApp_*_x64.msix`, rename to `.zip` and extract
6. Find these files in the `SnippingTool` folder:
   - oneocr.dll
   - oneocr.onemodel
   - onnxruntime.dll

### 2. Setup Directory Structure / Cấu trúc thư mục

```bash
cd oneocr

# Create directory for DLL files
mkdir -p oneocr_files

# Copy DLL files
cp /path/to/oneocr.dll oneocr_files/
cp /path/to/oneocr.onemodel oneocr_files/
cp /path/to/onnxruntime.dll oneocr_files/

# Verify files
ls -la oneocr_files/
```

### 3. Build Docker Image / Build Docker Image

```bash
# Build the image
docker-compose build

# Or build without cache if you have issues
docker-compose build --no-cache
```

### 4. Start the Container / Khởi động Container

```bash
# Start in background
docker-compose up -d

# Start with logs visible
docker-compose up

# Check logs
docker-compose logs -f
```

Wait 30-60 seconds for Wine initialization on first start.
Đợi 30-60 giây để Wine khởi tạo lần đầu.

### 5. Test the API / Kiểm tra API

**Test with curl:**
```bash
# Test with a JPEG image
curl -X POST \
  --data-binary "@test.jpg" \
  -H "Content-Type: image/jpeg" \
  http://localhost:8001/

# Test with a PNG image
curl -X POST \
  --data-binary "@test.png" \
  -H "Content-Type: image/png" \
  http://localhost:8001/
```

**Test with Python:**
```python
import requests

# Read image file
with open('test.jpg', 'rb') as f:
    image_data = f.read()

# Send request
response = requests.post('http://localhost:8001/', data=image_data)
result = response.json()

# Print results
print(result['text'])
```

**Run automated test:**
```bash
./test-docker.sh
```

### 6. Stop the Container / Dừng Container

```bash
# Stop
docker-compose stop

# Stop and remove
docker-compose down

# Stop, remove, and clean up volumes
docker-compose down -v
```

## Troubleshooting / Xử lý sự cố

### Container won't start / Container không khởi động

```bash
# Check logs
docker-compose logs

# Rebuild without cache
docker-compose down
docker-compose build --no-cache
docker-compose up
```

### "DLL file not found" error

```bash
# Verify files in container
docker exec oneocr-server ls -la /root/.config/oneocr/

# Should see:
# oneocr.dll
# oneocr.onemodel
# onnxruntime.dll

# If files are missing, check your volume mount:
ls -la oneocr_files/
```

### API not responding / API không phản hồi

```bash
# Check if container is running
docker ps | grep oneocr

# Check container health
docker inspect oneocr-server | grep -A 5 Health

# Check port binding
netstat -tlnp | grep 8001

# Test from inside container
docker exec oneocr-server curl http://localhost:8001/
```

### Performance issues / Vấn đề hiệu năng

```bash
# Increase memory limit in docker-compose.yml
# or create .env file:
echo "ONEOCR_MEMORY_LIMIT=4g" > .env
echo "ONEOCR_CPU_LIMIT=4" >> .env

# Restart
docker-compose down
docker-compose up -d
```

### Wine errors

```bash
# Enter container
docker exec -it oneocr-server bash

# Check Wine configuration
wine --version
winetricks list-installed

# Reinstall VC++ runtime
winetricks -q vcrun2019

# Test DLL loading
cd /root/.config/oneocr
wine cmd /c "dir"
```

## Common Use Cases / Các trường hợp sử dụng phổ biến

### As a microservice / Như một microservice

Add to your docker-compose.yml:
```yaml
services:
  your-app:
    ...
    depends_on:
      - oneocr
    environment:
      - ONEOCR_URL=http://oneocr:8001
      
  oneocr:
    image: oneocr:latest
    ports:
      - "8001:8001"
    volumes:
      - ./oneocr_files:/root/.config/oneocr:ro
```

### With Kubernetes / Với Kubernetes

See LINUX_DEPLOYMENT.md for Kubernetes deployment examples.

### Behind a reverse proxy / Sau reverse proxy

Nginx example:
```nginx
location /ocr/ {
    proxy_pass http://localhost:8001/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## Performance Tuning / Tối ưu hiệu năng

1. **Increase resources / Tăng tài nguyên:**
   ```bash
   # .env file
   ONEOCR_MEMORY_LIMIT=4g
   ONEOCR_CPU_LIMIT=4
   ```

2. **Use SSD for volumes / Dùng SSD cho volumes**

3. **Keep container running / Giữ container chạy:**
   - First start is slow due to Wine initialization
   - Subsequent requests are faster

4. **Pre-warm the container / Khởi động trước:**
   ```bash
   # Send a test request after startup
   sleep 60
   curl -X POST --data-binary "@warmup.jpg" http://localhost:8001/
   ```

## Next Steps / Bước tiếp theo

- Read [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md) for detailed documentation
- See [README.md](README.md) for API usage examples
- Check Docker logs for any issues: `docker-compose logs -f`

## Support / Hỗ trợ

If you encounter issues:
1. Check the logs: `docker-compose logs`
2. Run the test script: `./test-docker.sh`
3. Review [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md) troubleshooting section
4. Open an issue on GitHub with:
   - Your Docker version
   - Error logs
   - Steps to reproduce

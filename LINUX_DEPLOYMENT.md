# Deploying OneOCR in Linux Containers

## Overview

OneOCR sử dụng các file DLL từ Windows (oneocr.dll, onnxruntime.dll) để thực hiện OCR. Để chạy trên Linux, chúng ta sử dụng **Wine** - một lớp tương thích Windows cho phép chạy các ứng dụng Windows trên Linux.

OneOCR uses DLL files from Windows (oneocr.dll, onnxruntime.dll) to perform OCR. To run on Linux, we use **Wine** - a Windows compatibility layer that allows running Windows applications on Linux.

## Yêu cầu / Requirements

1. Docker và Docker Compose được cài đặt / Docker and Docker Compose installed
2. Các file DLL từ Windows 11 Snipping Tool / DLL files from Windows 11 Snipping Tool:
   - `oneocr.dll`
   - `oneocr.onemodel`
   - `onnxruntime.dll`

## Cách lấy các file DLL / How to Get DLL Files

### Bước 1: Tải Snipping Tool từ Microsoft Store
1. Truy cập: https://store.rg-adguard.net
2. Dán URL sau vào ô tìm kiếm: `https://apps.microsoft.com/detail/9mz95kl8mr0l`
3. Chọn "Slow" và tải file `.msixbundle` mới nhất của "Microsoft.ScreenSketch"

### Bước 2: Giải nén các file
1. Đổi tên file `.msixbundle` thành `.zip` và giải nén
2. Tìm file `SnippingToolApp_<version>_x64.msix` (hoặc ARM64 nếu dùng ARM)
3. Đổi tên thành `.zip` và giải nén
4. Các file cần thiết nằm trong thư mục `SnippingTool`:
   - `oneocr.dll`
   - `oneocr.onemodel`
   - `onnxruntime.dll`

### Step 1: Download Snipping Tool from Microsoft Store
1. Go to: https://store.rg-adguard.net
2. Paste this URL in the search box: `https://apps.microsoft.com/detail/9mz95kl8mr0l`
3. Select "Slow" and download the latest "Microsoft.ScreenSketch" `.msixbundle` file

### Step 2: Extract the Files
1. Rename the `.msixbundle` file to `.zip` and extract it
2. Find the `SnippingToolApp_<version>_x64.msix` file (or ARM64 if using ARM)
3. Rename it to `.zip` and extract it
4. The required files are in the `SnippingTool` folder:
   - `oneocr.dll`
   - `oneocr.onemodel`
   - `onnxruntime.dll`

## Cấu trúc thư mục / Directory Structure

```
oneocr/
├── Dockerfile
├── docker-compose.yml
├── oneocr.py
├── pyproject.toml
├── README.md
└── oneocr_files/          # Tạo thư mục này / Create this directory
    ├── oneocr.dll
    ├── oneocr.onemodel
    └── onnxruntime.dll
```

## Triển khai / Deployment

### Phương pháp 1: Sử dụng Docker Compose (Khuyên dùng / Recommended)

```bash
# 1. Tạo thư mục cho các file DLL
mkdir -p oneocr_files

# 2. Sao chép các file DLL vào thư mục oneocr_files
cp /path/to/oneocr.dll oneocr_files/
cp /path/to/oneocr.onemodel oneocr_files/
cp /path/to/onnxruntime.dll oneocr_files/

# 3. Build và chạy container
docker-compose up -d

# 4. Kiểm tra logs
docker-compose logs -f

# 5. Test API
curl -X POST -F "image=@test.jpg" http://localhost:8001/
```

### Phương pháp 2: Sử dụng Docker trực tiếp / Method 2: Using Docker directly

```bash
# Build image
docker build -t oneocr:latest .

# Run container
docker run -d \
  --name oneocr-server \
  -p 8001:8001 \
  -v $(pwd)/oneocr_files:/root/.config/oneocr:ro \
  -e ONEOCR_WINE_MODE=1 \
  oneocr:latest
```

## Sử dụng API / Using the API

### Python Example

```python
import requests

# Đọc file ảnh / Read image file
with open('test.jpg', 'rb') as f:
    image_bytes = f.read()

# Gửi request đến API / Send request to API
response = requests.post('http://localhost:8001/', data=image_bytes)
result = response.json()

# In kết quả / Print results
print("Văn bản nhận diện / Recognized text:")
print(result['text'])
print(f"\nGóc văn bản / Text angle: {result['text_angle']}")
print(f"Số dòng / Number of lines: {len(result['lines'])}")
```

### cURL Example

```bash
curl -X POST \
  --data-binary "@test.jpg" \
  -H "Content-Type: image/jpeg" \
  http://localhost:8001/
```

## Giới hạn và Lưu ý / Limitations and Notes

### Hiệu năng / Performance
- **Wine overhead**: Chạy DLL Windows qua Wine có thể chậm hơn 20-40% so với Windows native / Running Windows DLLs through Wine can be 20-40% slower than native Windows
- **Khởi động lâu / Slow startup**: Container có thể mất 30-60 giây để khởi động do Wine initialization
- **Bộ nhớ / Memory**: Container cần ít nhất 2GB RAM / Container requires at least 2GB RAM

### Tương thích / Compatibility
- ✅ **Hoạt động / Works**: Nhận diện văn bản cơ bản / Basic text recognition
- ✅ **Hoạt động / Works**: Multi-line text, bounding boxes, confidence scores
- ⚠️ **Có thể gặp vấn đề / May have issues**: Một số font Unicode phức tạp / Some complex Unicode fonts
- ⚠️ **Có thể gặp vấn đề / May have issues**: Rendering issues với một số định dạng ảnh / Rendering issues with some image formats

### Bảo mật / Security
- File DLL được mount dưới dạng read-only / DLL files are mounted as read-only
- Container chạy với non-root user được khuyến nghị cho production / Running container as non-root user is recommended for production
- Cân nhắc sử dụng network isolation / Consider using network isolation

## Khắc phục sự cố / Troubleshooting

### Vấn đề 1: "DLL file not found"
**Nguyên nhân / Cause**: Các file DLL chưa được đặt đúng vị trí

**Giải pháp / Solution**:
```bash
# Kiểm tra file tồn tại / Check if files exist
ls -la oneocr_files/

# Nên thấy / Should see:
# oneocr.dll
# oneocr.onemodel
# onnxruntime.dll
```

### Vấn đề 2: "Wine initialization failed"
**Nguyên nhân / Cause**: Wine chưa được cài đặt đầy đủ dependencies

**Giải pháp / Solution**:
```bash
# Rebuild container với cache bị xóa / Rebuild container with clean cache
docker-compose build --no-cache
docker-compose up -d
```

### Vấn đề 3: Container khởi động chậm / Slow container startup
**Nguyên nhân / Cause**: Wine đang khởi tạo lần đầu

**Giải pháp / Solution**:
- Chờ 30-60 giây / Wait 30-60 seconds
- Kiểm tra logs: `docker-compose logs -f`
- Container sẽ nhanh hơn sau lần khởi động đầu tiên / Container will be faster after first startup

### Vấn đề 4: "ModuleNotFoundError" hoặc missing dependencies
**Giải pháp / Solution**:
```bash
# Vào container để debug / Enter container for debugging
docker exec -it oneocr-server bash

# Kiểm tra Python packages / Check Python packages
pip3 list | grep -E "PIL|fastapi|uvicorn"

# Cài đặt lại nếu cần / Reinstall if needed
pip3 install --force-reinstall Pillow fastapi uvicorn
```

## Kiểm tra sức khỏe / Health Check

```bash
# Kiểm tra container đang chạy / Check if container is running
docker ps | grep oneocr

# Kiểm tra health status
docker inspect oneocr-server | grep -A 5 Health

# Test API endpoint
curl http://localhost:8001/
```

## Kết luận / Conclusion

**Có thể triển khai OneOCR với DLL Windows trên Linux container?**
**Can OneOCR with Windows DLLs be deployed on Linux containers?**

✅ **Có / YES** - Nhưng với một số giới hạn:
✅ **YES** - But with some limitations:

1. **Cần Wine**: Phải dùng Wine để chạy Windows DLLs / Wine is required to run Windows DLLs
2. **Hiệu năng thấp hơn**: Chậm hơn 20-40% so với Windows native / 20-40% slower than native Windows
3. **Tốn tài nguyên hơn**: Cần nhiều RAM và CPU hơn / Requires more RAM and CPU
4. **Phức tạp hơn**: Setup và troubleshooting phức tạp hơn / More complex setup and troubleshooting

**Khuyến nghị / Recommendations**:
- Sử dụng cho môi trường development/testing / Use for development/testing environments
- Cân nhắc các giải pháp OCR native Linux (Tesseract, PaddleOCR) cho production / Consider native Linux OCR solutions (Tesseract, PaddleOCR) for production
- Monitor hiệu năng và resource usage / Monitor performance and resource usage
- Chuẩn bị fallback plan nếu Wine có vấn đề / Prepare fallback plan if Wine has issues

## Tài liệu tham khảo / References

- Wine Documentation: https://www.winehq.org/documentation
- Docker Documentation: https://docs.docker.com/
- Original OneOCR: https://github.com/AuroraWright/oneocr

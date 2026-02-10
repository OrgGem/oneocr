# Hướng dẫn Swagger UI / Swagger UI Guide

## Tổng quan / Overview

OneOCR API hiện đã được tích hợp với Swagger/OpenAPI documentation. Bạn có thể truy cập giao diện tương tác để kiểm tra và test API.

OneOCR API now includes integrated Swagger/OpenAPI documentation. You can access the interactive interface to explore and test the API.

---

## 🚀 Cách truy cập / How to Access

### 1. Khởi động server / Start the server

```bash
# Sử dụng Docker
docker-compose up -d

# Hoặc chạy trực tiếp
pip install oneocr[api]
oneocr_serve
```

### 2. Truy cập Swagger UI

Sau khi server đang chạy, mở trình duyệt và truy cập:

After the server is running, open your browser and visit:

#### **Swagger UI** (Interactive API Documentation)
```
http://localhost:8001/docs
```

#### **ReDoc** (Alternative Documentation)
```
http://localhost:8001/redoc
```

#### **OpenAPI JSON Schema**
```
http://localhost:8001/openapi.json
```

---

## 📖 Tính năng Swagger UI / Swagger UI Features

### 1. Xem tài liệu API / View API Documentation
- Xem tất cả endpoints có sẵn / View all available endpoints
- Xem request/response schemas / View request/response schemas
- Xem ví dụ requests và responses / View example requests and responses

### 2. Test API trực tiếp / Test API Directly
- **Try it out**: Nhấn nút "Try it out" để test endpoint
- **Execute**: Điền thông tin và nhấn "Execute" để gửi request
- **Response**: Xem kết quả trả về ngay lập tức

### 3. Tải xuống OpenAPI Spec / Download OpenAPI Spec
- Có thể tải xuống file OpenAPI JSON để sử dụng với các công cụ khác
- Can download OpenAPI JSON file to use with other tools

---

## 🎯 Sử dụng Swagger UI / Using Swagger UI

### Test API với hình ảnh / Testing API with an Image

1. **Mở Swagger UI**: http://localhost:8001/docs

2. **Tìm endpoint** `POST /`:
   - Nhấn vào endpoint để mở chi tiết
   - Click on the endpoint to open details

3. **Nhấn "Try it out"**:
   - Nút này cho phép bạn test API
   - This button allows you to test the API

4. **Tải lên ảnh / Upload Image**:
   
   **Cách 1: Dùng cURL**
   ```bash
   curl -X 'POST' \
     'http://localhost:8001/' \
     -H 'accept: application/json' \
     -H 'Content-Type: image/jpeg' \
     --data-binary '@/path/to/your/image.jpg'
   ```

   **Cách 2: Dùng Python**
   ```python
   import requests
   
   with open('image.jpg', 'rb') as f:
       response = requests.post(
           'http://localhost:8001/',
           data=f.read(),
           headers={'Content-Type': 'image/jpeg'}
       )
   
   print(response.json())
   ```

5. **Xem kết quả / View Results**:
   - Swagger UI sẽ hiển thị response với:
     - Status code
     - Response headers
     - Response body (JSON)

---

## 📊 API Endpoints Có Sẵn / Available API Endpoints

### 1. POST `/` - Text Recognition

**Mô tả / Description:**
Nhận diện văn bản từ hình ảnh / Recognize text from image

**Request:**
- Body: Binary image data
- Content-Type: `image/jpeg`, `image/png`, etc.

**Response:**
```json
{
  "text": "Extracted text",
  "text_angle": 0.064377,
  "lines": [
    {
      "text": "Line text",
      "bounding_rect": {
        "x1": 13.0, "y1": 38.0,
        "x2": 458.0, "y2": 38.0,
        "x3": 458.0, "y3": 77.0,
        "x4": 13.0, "y4": 76.0
      },
      "words": [
        {
          "text": "Word",
          "bounding_rect": {...},
          "confidence": 0.987
        }
      ]
    }
  ]
}
```

### 2. GET `/health` - Health Check

**Mô tả / Description:**
Kiểm tra trạng thái API / Check API health

**Response:**
```json
{
  "status": "healthy",
  "service": "OneOCR API",
  "version": "1.0.11"
}
```

---

## 🔧 Cấu trúc Response / Response Structure

### OCRResult Schema

| Field | Type | Description (VI) | Description (EN) |
|-------|------|------------------|------------------|
| `text` | string | Toàn bộ văn bản | Full extracted text |
| `text_angle` | float | Góc xoay văn bản (radians) | Text rotation angle (radians) |
| `lines` | array | Danh sách các dòng | List of text lines |
| `error` | string | Thông báo lỗi (nếu có) | Error message (if any) |

### Line Schema

| Field | Type | Description (VI) | Description (EN) |
|-------|------|------------------|------------------|
| `text` | string | Nội dung dòng | Line text content |
| `bounding_rect` | object | Tọa độ hộp giới hạn | Bounding box coordinates |
| `words` | array | Các từ trong dòng | Words in the line |

### Word Schema

| Field | Type | Description (VI) | Description (EN) |
|-------|------|------------------|------------------|
| `text` | string | Từ | Word text |
| `bounding_rect` | object | Tọa độ từ | Word coordinates |
| `confidence` | float | Độ tin cậy (0-1) | Confidence score (0-1) |

### BoundingRect Schema

| Field | Type | Description (VI) | Description (EN) |
|-------|------|------------------|------------------|
| `x1, y1` | float | Góc trên-trái | Top-left corner |
| `x2, y2` | float | Góc trên-phải | Top-right corner |
| `x3, y3` | float | Góc dưới-phải | Bottom-right corner |
| `x4, y4` | float | Góc dưới-trái | Bottom-left corner |

---

## 💡 Ví dụ sử dụng / Usage Examples

### Example 1: Test từ Swagger UI / Test from Swagger UI

1. Mở http://localhost:8001/docs
2. Nhấn vào `POST /`
3. Nhấn "Try it out"
4. Dán base64 của ảnh hoặc dùng cURL command được generate
5. Nhấn "Execute"
6. Xem kết quả bên dưới

### Example 2: Python Script

```python
import requests
import json

# Test API
url = "http://localhost:8001/"

with open("test.jpg", "rb") as f:
    image_data = f.read()

response = requests.post(url, data=image_data)

# Parse result
result = response.json()

print("Recognized Text:")
print(result['text'])

print("\nDetailed Info:")
print(f"Text Angle: {result['text_angle']}")
print(f"Number of Lines: {len(result['lines'])}")

for i, line in enumerate(result['lines'], 1):
    print(f"\nLine {i}: {line['text']}")
    print(f"  Words: {len(line['words'])}")
    
    for word in line['words']:
        print(f"    - {word['text']} (confidence: {word['confidence']:.2%})")
```

### Example 3: cURL Command

```bash
# Test health check
curl http://localhost:8001/health

# Test OCR with image
curl -X POST \
  http://localhost:8001/ \
  -H "Content-Type: image/jpeg" \
  --data-binary "@image.jpg" \
  | jq '.'
```

### Example 4: JavaScript/Node.js

```javascript
const fs = require('fs');
const fetch = require('node-fetch');

async function recognizeText(imagePath) {
    const imageBuffer = fs.readFileSync(imagePath);
    
    const response = await fetch('http://localhost:8001/', {
        method: 'POST',
        body: imageBuffer,
        headers: {
            'Content-Type': 'image/jpeg'
        }
    });
    
    const result = await response.json();
    
    console.log('Text:', result.text);
    console.log('Lines:', result.lines.length);
    
    return result;
}

recognizeText('test.jpg');
```

---

## 🔍 Tính năng nâng cao / Advanced Features

### 1. Export OpenAPI Specification

Tải xuống OpenAPI spec để sử dụng với Postman, Insomnia, hoặc các công cụ khác:

Download OpenAPI spec to use with Postman, Insomnia, or other tools:

```bash
curl http://localhost:8001/openapi.json > oneocr-openapi.json
```

### 2. Generate Client Code

Sử dụng OpenAPI Generator để tạo client code:

Use OpenAPI Generator to create client code:

```bash
# Install OpenAPI Generator
npm install -g @openapitools/openapi-generator-cli

# Generate Python client
openapi-generator-cli generate \
  -i http://localhost:8001/openapi.json \
  -g python \
  -o ./python-client

# Generate JavaScript client
openapi-generator-cli generate \
  -i http://localhost:8001/openapi.json \
  -g javascript \
  -o ./js-client
```

### 3. Import vào Postman

1. Mở Postman
2. File → Import
3. Chọn "Link" tab
4. Dán: `http://localhost:8001/openapi.json`
5. Click "Continue" và "Import"

---

## 📝 Lưu ý / Notes

### Giới hạn / Limitations

- Kích thước ảnh: 50x50 đến 10000x10000 pixels
- Image size: 50x50 to 10000x10000 pixels

- Định dạng hỗ trợ: JPEG, PNG, BMP, và các định dạng PIL/Pillow hỗ trợ
- Supported formats: JPEG, PNG, BMP, and PIL/Pillow supported formats

### Lỗi thường gặp / Common Errors

**400 Bad Request:**
- Ảnh quá nhỏ (< 50x50) hoặc quá lớn (> 10000x10000)
- Image too small (< 50x50) or too large (> 10000x10000)

**500 Internal Server Error:**
- DLL không tìm thấy hoặc không load được
- DLL not found or failed to load
- Ảnh không đọc được
- Image cannot be read

---

## 🌐 CORS Configuration

API đã được cấu hình CORS để chấp nhận requests từ mọi nguồn:

API is configured with CORS to accept requests from any origin:

```python
allow_origins=['*']
allow_methods=['*']
allow_headers=['*']
```

Điều này cho phép test từ Swagger UI và các ứng dụng web khác.

This allows testing from Swagger UI and other web applications.

---

## 📚 Tài liệu liên quan / Related Documentation

- [API_DOCUMENTATION.md](API_DOCUMENTATION.md) - Complete API documentation
- [README.md](README.md) - General overview
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md) - Linux deployment guide

---

## 🎉 Kết luận / Conclusion

Swagger UI giúp bạn:
- Hiểu rõ API structure
- Test API dễ dàng không cần code
- Xem ví dụ request/response
- Generate client code tự động
- Export OpenAPI specification

Swagger UI helps you:
- Understand API structure clearly
- Test API easily without code
- View example requests/responses
- Generate client code automatically
- Export OpenAPI specification

**Truy cập ngay:** http://localhost:8001/docs

**Access now:** http://localhost:8001/docs

---

**Last Updated:** February 2026  
**Version:** 1.0.11

# Swagger UI Demo / Minh họa Swagger UI

## 📸 Giao diện Swagger UI / Swagger UI Interface

Khi bạn truy cập `http://localhost:8001/docs`, bạn sẽ thấy giao diện như sau:

When you access `http://localhost:8001/docs`, you will see an interface like this:

```
╔════════════════════════════════════════════════════════════════╗
║                         OneOCR API                             ║
║                        Version: 1.0.11                         ║
╚════════════════════════════════════════════════════════════════╝

OneOCR - Text Recognition API

OneOCR cung cấp API để nhận diện văn bản từ hình ảnh sử dụng 
Windows 11 Snipping Tool OCR.

OneOCR provides an API for text recognition from images using 
Windows 11 Snipping Tool OCR.

Tính năng / Features

✅ Text Recognition - Nhận diện văn bản từ ảnh
✅ Multi-line Detection - Phát hiện nhiều dòng văn bản
✅ Word Segmentation - Phân tách từng từ
✅ Bounding Boxes - Vị trí văn bản
✅ Confidence Scores - Độ tin cậy (0-1)
✅ Text Angle - Góc xoay văn bản

❌ Table Recognition - KHÔNG hỗ trợ
❌ Form Processing - KHÔNG hỗ trợ

─────────────────────────────────────────────────────────────────

┌─────────────────────────────────────────────────────────────┐
│ OCR                                                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ▼ POST /                                                   │
│     Nhận diện văn bản từ ảnh / Recognize text from image   │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Health                                                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ▼ GET /health                                              │
│     Kiểm tra trạng thái / Health check                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘

─────────────────────────────────────────────────────────────────

Schemas
  • BoundingRect
  • Line
  • OCRResult
  • Word
```

---

## 🎯 Chi tiết Endpoint POST / / POST / Endpoint Details

Khi nhấn vào `POST /`, bạn sẽ thấy:

When you click on `POST /`, you will see:

```
╔═══════════════════════════════════════════════════════════════╗
║ POST /                                                        ║
║ Nhận diện văn bản từ ảnh / Recognize text from image         ║
╚═══════════════════════════════════════════════════════════════╝

Nhận diện văn bản từ hình ảnh và trả về kết quả với thông tin 
chi tiết.

Recognize text from an image and return detailed results.

┌───────────────────────────────────────────────────────────────┐
│ Request                                                       │
├───────────────────────────────────────────────────────────────┤
│ Gửi dữ liệu ảnh dạng binary trong request body.              │
│ Send binary image data in the request body.                  │
│                                                               │
│ Content-Type: image/jpeg, image/png, hoặc định dạng ảnh khác │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│ Response                                                      │
├───────────────────────────────────────────────────────────────┤
│ Returns JSON containing:                                      │
│                                                               │
│ • text: Toàn bộ văn bản / Full extracted text                │
│ • text_angle: Góc xoay văn bản / Text rotation angle         │
│ • lines: Danh sách các dòng / List of text lines             │
│   - text: Nội dung dòng / Line text                          │
│   - bounding_rect: Tọa độ hộp / Bounding box coordinates     │
│   - words: Các từ trong dòng / Words in line                 │
│     • text: Từ / Word                                        │
│     • bounding_rect: Tọa độ từ / Word coordinates            │
│     • confidence: Độ tin cậy / Confidence score (0-1)        │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│ Try it out                                    [Execute] [Clear]│
├───────────────────────────────────────────────────────────────┤
│                                                               │
│ Request body                                                  │
│ ┌─────────────────────────────────────────────────────────┐  │
│ │ application/json                                        │  │
│ │                                                         │  │
│ │ [Binary image data]                                     │  │
│ │                                                         │  │
│ └─────────────────────────────────────────────────────────┘  │
│                                                               │
│                                 [Execute]                     │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│ Responses                                                     │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│ ▼ 200 - Nhận diện thành công / Recognition successful        │
│   Media type: application/json                                │
│                                                               │
│   Example Value | Schema                                      │
│   ┌───────────────────────────────────────────────────────┐  │
│   │ {                                                     │  │
│   │   "text": "Hello World",                              │  │
│   │   "text_angle": 0.0,                                  │  │
│   │   "lines": [                                          │  │
│   │     {                                                 │  │
│   │       "text": "Hello World",                          │  │
│   │       "bounding_rect": {                              │  │
│   │         "x1": 10.0, "y1": 10.0,                       │  │
│   │         "x2": 100.0, "y2": 10.0,                      │  │
│   │         "x3": 100.0, "y3": 30.0,                      │  │
│   │         "x4": 10.0, "y4": 30.0                        │  │
│   │       },                                              │  │
│   │       "words": [                                      │  │
│   │         {                                             │  │
│   │           "text": "Hello",                            │  │
│   │           "bounding_rect": {...},                     │  │
│   │           "confidence": 0.99                          │  │
│   │         },                                            │  │
│   │         {                                             │  │
│   │           "text": "World",                            │  │
│   │           "bounding_rect": {...},                     │  │
│   │           "confidence": 0.98                          │  │
│   │         }                                             │  │
│   │       ]                                               │  │
│   │     }                                                 │  │
│   │   ]                                                   │  │
│   │ }                                                     │  │
│   └───────────────────────────────────────────────────────┘  │
│                                                               │
│ ▼ 400 - Yêu cầu không hợp lệ / Invalid request               │
│   Media type: application/json                                │
│   Example: {"text": "", "error": "Unsupported image size"}   │
│                                                               │
│ ▼ 500 - Lỗi xử lý / Processing error                         │
│   Media type: application/json                                │
│   Example: {"text": "", "error": "DLL initialization failed"}│
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

---

## 🔧 Chi tiết Endpoint GET /health / GET /health Endpoint Details

```
╔═══════════════════════════════════════════════════════════════╗
║ GET /health                                                   ║
║ Kiểm tra trạng thái / Health check                           ║
╚═══════════════════════════════════════════════════════════════╝

Kiểm tra xem API có hoạt động không
Check if API is running

┌───────────────────────────────────────────────────────────────┐
│ Try it out                                    [Execute] [Clear]│
├───────────────────────────────────────────────────────────────┤
│                                                               │
│ No parameters                                                 │
│                                                               │
│                                 [Execute]                     │
└───────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────────┐
│ Responses                                                     │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│ ▼ 200 - Successful Response                                  │
│   Media type: application/json                                │
│                                                               │
│   ┌───────────────────────────────────────────────────────┐  │
│   │ {                                                     │  │
│   │   "status": "healthy",                                │  │
│   │   "service": "OneOCR API",                            │  │
│   │   "version": "1.0.11"                                 │  │
│   │ }                                                     │  │
│   └───────────────────────────────────────────────────────┘  │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

---

## 📋 Schemas Section

Ở cuối trang Swagger UI, bạn sẽ thấy phần Schemas:

At the bottom of the Swagger UI page, you will see the Schemas section:

```
╔═══════════════════════════════════════════════════════════════╗
║ Schemas                                                       ║
╚═══════════════════════════════════════════════════════════════╝

▼ BoundingRect
  Bounding box coordinates for text region
  ┌───────────────────────────────────────────────────────────┐
  │ x1*    number    Top-left X coordinate                    │
  │ y1*    number    Top-left Y coordinate                    │
  │ x2*    number    Top-right X coordinate                   │
  │ y2*    number    Top-right Y coordinate                   │
  │ x3*    number    Bottom-right X coordinate                │
  │ y3*    number    Bottom-right Y coordinate                │
  │ x4*    number    Bottom-left X coordinate                 │
  │ y4*    number    Bottom-left Y coordinate                 │
  └───────────────────────────────────────────────────────────┘

▼ Word
  Individual word recognition result
  ┌───────────────────────────────────────────────────────────┐
  │ text             string    Recognized word text           │
  │ bounding_rect    object    Word bounding box              │
  │ confidence       number    Recognition confidence (0-1)   │
  └───────────────────────────────────────────────────────────┘

▼ Line
  Text line recognition result
  ┌───────────────────────────────────────────────────────────┐
  │ text             string    Full line text                 │
  │ bounding_rect    object    Line bounding box              │
  │ words            array     Words in this line             │
  └───────────────────────────────────────────────────────────┘

▼ OCRResult
  OCR processing result
  ┌───────────────────────────────────────────────────────────┐
  │ text*            string    Full extracted text from image │
  │ text_angle       number    Text rotation angle (radians)  │
  │ lines            array     Detected text lines            │
  │ error            string    Error message if failed        │
  └───────────────────────────────────────────────────────────┘
```

---

## 💻 cURL Command Generated by Swagger

Khi nhấn "Try it out" và "Execute", Swagger sẽ tạo cURL command:

When you click "Try it out" and "Execute", Swagger generates a cURL command:

```bash
curl -X 'POST' \
  'http://localhost:8001/' \
  -H 'accept: application/json' \
  -H 'Content-Type: image/jpeg' \
  --data-binary '@/path/to/image.jpg'
```

---

## 🔍 Request Sample Code

Swagger UI cũng cung cấp code samples trong nhiều ngôn ngữ:

Swagger UI also provides code samples in multiple languages:

### Python
```python
import requests

url = "http://localhost:8001/"
files = {'file': open('image.jpg', 'rb')}

response = requests.post(url, files=files)
print(response.json())
```

### JavaScript (fetch)
```javascript
fetch('http://localhost:8001/', {
  method: 'POST',
  body: imageBlob,
  headers: {
    'Content-Type': 'image/jpeg'
  }
})
.then(response => response.json())
.then(data => console.log(data));
```

### Java
```java
OkHttpClient client = new OkHttpClient();

RequestBody body = RequestBody.create(
    MediaType.parse("image/jpeg"),
    imageFile
);

Request request = new Request.Builder()
    .url("http://localhost:8001/")
    .post(body)
    .build();

Response response = client.newCall(request).execute();
```

---

## 🎨 ReDoc Alternative View

Truy cập `http://localhost:8001/redoc` để xem giao diện ReDoc:

Access `http://localhost:8001/redoc` to see the ReDoc interface:

```
╔════════════════════════════════════════════════════════════════╗
║                         OneOCR API                             ║
║                        Version 1.0.11                          ║
╚════════════════════════════════════════════════════════════════╝

OneOCR - Text Recognition API

[Detailed description in markdown format...]

┌────────────────────────────────────────────────────────────────┐
│ Table of Contents                                              │
├────────────────────────────────────────────────────────────────┤
│ • OCR                                                          │
│   - POST /                                                     │
│ • Health                                                       │
│   - GET /health                                                │
│ • Schemas                                                      │
│   - BoundingRect                                               │
│   - Line                                                       │
│   - OCRResult                                                  │
│   - Word                                                       │
└────────────────────────────────────────────────────────────────┘

[Detailed documentation for each endpoint...]
```

---

## 📥 Export OpenAPI Specification

Truy cập `http://localhost:8001/openapi.json` để lấy OpenAPI spec:

Access `http://localhost:8001/openapi.json` to get the OpenAPI spec:

```json
{
  "openapi": "3.0.2",
  "info": {
    "title": "OneOCR API",
    "description": "OneOCR - Text Recognition API...",
    "version": "1.0.11",
    "contact": {
      "name": "OneOCR Team",
      "url": "https://github.com/OrgGem/oneocr"
    },
    "license": {
      "name": "MIT License",
      "url": "https://github.com/OrgGem/oneocr/blob/main/LICENSE"
    }
  },
  "paths": {
    "/": {
      "post": {
        "summary": "Nhận diện văn bản từ ảnh / Recognize text from image",
        "operationId": "process_image__post",
        "responses": {
          "200": {
            "description": "Nhận diện thành công / Recognition successful",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/OCRResult"
                }
              }
            }
          }
        },
        "tags": ["OCR"]
      }
    },
    "/health": {
      "get": {
        "summary": "Kiểm tra trạng thái / Health check",
        "operationId": "health_check_health_get",
        "responses": {
          "200": {
            "description": "Successful Response"
          }
        },
        "tags": ["Health"]
      }
    }
  },
  "components": {
    "schemas": {
      "BoundingRect": {...},
      "Word": {...},
      "Line": {...},
      "OCRResult": {...}
    }
  }
}
```

---

## ✨ Interactive Features

### 1. Try It Out Button
- Click "Try it out" để enable form inputs
- Nhập hoặc upload dữ liệu
- Click "Execute" để gửi request

### 2. Response Display
- Xem Response body (JSON)
- Xem Response headers
- Xem Response code
- Xem cURL command equivalent

### 3. Schema Exploration
- Click vào schema names để xem chi tiết
- Xem required vs optional fields
- Xem field descriptions và types
- Xem example values

### 4. Authorization (if needed)
- Swagger UI có built-in authorization UI
- Hiện tại OneOCR không yêu cầu auth

---

## 🎯 Tips for Using Swagger UI

1. **Test từng endpoint:**
   - Nhấn "Try it out"
   - Điền dữ liệu cần thiết
   - Nhấn "Execute"
   - Xem response

2. **Copy cURL commands:**
   - Swagger tạo cURL commands tự động
   - Copy và chạy trong terminal

3. **View schemas:**
   - Scroll xuống cuối page
   - Xem chi tiết data structures

4. **Export specification:**
   - Download OpenAPI JSON
   - Import vào Postman hoặc Insomnia

5. **Use ReDoc for reading:**
   - ReDoc có layout dễ đọc hơn
   - Tốt cho documentation reference

---

## 📝 Summary / Tóm tắt

Swagger UI cung cấp:
- ✅ Interactive API documentation
- ✅ Try-it-out functionality
- ✅ Auto-generated code samples
- ✅ Schema visualization
- ✅ Export OpenAPI specification

Access links:
- Swagger UI: http://localhost:8001/docs
- ReDoc: http://localhost:8001/redoc
- OpenAPI JSON: http://localhost:8001/openapi.json

Swagger UI provides:
- ✅ Interactive API documentation
- ✅ Try-it-out functionality
- ✅ Auto-generated code samples
- ✅ Schema visualization
- ✅ Export OpenAPI specification

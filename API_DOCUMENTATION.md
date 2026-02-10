# OneOCR API Documentation / Tài liệu API OneOCR

## Tổng quan / Overview

### Câu hỏi được đặt ra / Questions Asked
**Vietnamese:** Hãy kiểm tra giúp tôi các API đang được cung cấp trên ứng dụng là gì, có thể xử lý tác vụ gì? Có khả năng nhận diện table không vì tôi nhớ trong OneOCR có tính năng này.

**English:** Please check what APIs are currently provided in the application, what tasks can they handle? Does it have table recognition capability as I remember OneOCR having this feature?

---

## 📋 Kết luận ngắn gọn / Quick Summary

### ✅ API hiện có / Available APIs
OneOCR hiện tại cung cấp **1 API endpoint chính** để nhận diện văn bản từ hình ảnh.

OneOCR currently provides **1 main API endpoint** for text recognition from images.

### ❌ Nhận diện bảng / Table Recognition
**KHÔNG** - Phiên bản OneOCR này **KHÔNG HỖ TRỢ** nhận diện bảng (table detection/recognition).

**NO** - This version of OneOCR **DOES NOT SUPPORT** table detection/recognition.

---

## 🔌 API Endpoints / Các điểm cuối API

### 1. POST `/` - Text Recognition / Nhận diện văn bản

**Mô tả / Description:**
- Endpoint chính để nhận diện văn bản từ hình ảnh
- Main endpoint for text recognition from images

**Method:** POST

**URL:** `http://localhost:8001/`

**Content-Type:** `image/jpeg`, `image/png`, or any image format

**Request Body:**
- Raw binary image data
- Dữ liệu nhị phân của hình ảnh

**Response Format:** JSON

**Response Structure:**
```json
{
  "text": "Full extracted text",
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
          "bounding_rect": {
            "x1": 14.35, "y1": 39.69,
            "x2": 140.34, "y2": 41.31,
            "x3": 139.93, "y3": 73.41,
            "x4": 13.77, "y4": 74.08
          },
          "confidence": 0.987
        }
      ]
    }
  ]
}
```

---

## 🎯 Chức năng hiện có / Current Capabilities

### 1. Text Recognition / Nhận diện văn bản
✅ **Có hỗ trợ / Supported**

**Mô tả / Description:**
- Nhận diện văn bản từ hình ảnh
- Extract text from images

**Các tính năng / Features:**
- Multi-line text detection / Phát hiện văn bản nhiều dòng
- Word-level segmentation / Phân đoạn cấp từ
- Confidence scores / Điểm tin cậy
- Bounding boxes / Hộp giới hạn
- Text angle detection / Phát hiện góc văn bản

### 2. Bounding Box Detection / Phát hiện hộp giới hạn
✅ **Có hỗ trợ / Supported**

**Mô tả / Description:**
- Xác định vị trí của văn bản trong ảnh
- Identify text location in images

**Thông tin trả về / Returned Information:**
- Line-level bounding boxes / Hộp giới hạn cấp dòng
- Word-level bounding boxes / Hộp giới hạn cấp từ
- 4 điểm góc cho mỗi hộp / 4 corner points for each box

### 3. Confidence Scores / Điểm tin cậy
✅ **Có hỗ trợ / Supported**

**Mô tả / Description:**
- Độ tin cậy của việc nhận diện từng từ
- Confidence level for each recognized word

**Phạm vi / Range:** 0.0 - 1.0 (0% - 100%)

### 4. Text Angle Detection / Phát hiện góc văn bản
✅ **Có hỗ trợ / Supported**

**Mô tả / Description:**
- Góc nghiêng của văn bản trong ảnh
- Text skew angle in the image

**Đơn vị / Unit:** Radians

---

## ❌ Chức năng KHÔNG hỗ trợ / NOT Supported Features

### 1. Table Recognition / Nhận diện bảng
❌ **KHÔNG hỗ trợ / NOT Supported**

**Giải thích / Explanation:**
- OneOCR này sử dụng Windows 11 Snipping Tool OCR DLLs
- DLLs chỉ cung cấp text recognition cơ bản
- **KHÔNG có** các hàm DLL cho table detection
- This OneOCR uses Windows 11 Snipping Tool OCR DLLs
- DLLs only provide basic text recognition
- **NO** DLL functions for table detection

**Các hàm DLL có sẵn / Available DLL Functions:**
```python
# Text recognition functions only
CreateOcrPipeline
RunOcrPipeline
GetOcrLineCount
GetOcrLine
GetOcrLineContent
GetOcrLineBoundingBox
GetOcrWord
GetOcrWordContent
GetOcrWordBoundingBox
GetOcrWordConfidence
GetImageAngle

# NO table-related functions like:
# GetTableCount ❌
# GetTableCells ❌
# GetTableStructure ❌
```

### 2. Table Structure Detection / Phát hiện cấu trúc bảng
❌ **KHÔNG hỗ trợ / NOT Supported**

- Không thể phát hiện hàng và cột / Cannot detect rows and columns
- Không thể phát hiện ô bảng / Cannot detect table cells
- Không thể xác định cấu trúc bảng / Cannot identify table structure

### 3. Form Recognition / Nhận diện biểu mẫu
❌ **KHÔNG hỗ trợ / NOT Supported**

- Không có phát hiện key-value pairs / No key-value pair detection
- Không có nhận diện trường biểu mẫu / No form field recognition

---

## 📖 Ví dụ sử dụng / Usage Examples

### Example 1: Python with PIL

```python
from PIL import Image
import oneocr

# Load image
img = Image.open('document.jpg')

# Initialize OCR engine
model = oneocr.OcrEngine()

# Recognize text
result = model.recognize_pil(img)

# Print results
print("Text:", result['text'])
print("Angle:", result['text_angle'])
print("Lines:", len(result['lines']))

# Access word-level details
for line in result['lines']:
    print(f"Line: {line['text']}")
    for word in line['words']:
        print(f"  Word: {word['text']} (confidence: {word['confidence']:.2f})")
```

### Example 2: Python with OpenCV

```python
import cv2
import oneocr

# Load image
img = cv2.imread('document.jpg')

# Initialize OCR engine
model = oneocr.OcrEngine()

# Recognize text
result = model.recognize_cv2(img)

# Print text
print(result['text'])
```

### Example 3: HTTP API with cURL

```bash
# Send image for OCR
curl -X POST \
  --data-binary "@document.jpg" \
  -H "Content-Type: image/jpeg" \
  http://localhost:8001/

# Or with PNG
curl -X POST \
  --data-binary "@screenshot.png" \
  -H "Content-Type: image/png" \
  http://localhost:8001/
```

### Example 4: HTTP API with Python requests

```python
import requests

# Read image file
with open('document.jpg', 'rb') as f:
    image_data = f.read()

# Send to API
response = requests.post('http://localhost:8001/', data=image_data)
result = response.json()

# Process results
print("Recognized text:")
print(result['text'])

# Extract all words with high confidence
high_conf_words = []
for line in result['lines']:
    for word in line['words']:
        if word['confidence'] > 0.95:
            high_conf_words.append(word['text'])

print("\nHigh confidence words:", high_conf_words)
```

### Example 5: Processing Response Data

```python
import requests
import json

# Send image
response = requests.post(
    'http://localhost:8001/',
    data=open('invoice.jpg', 'rb').read()
)
result = response.json()

# Extract text by lines
print("Text by lines:")
for i, line in enumerate(result['lines'], 1):
    print(f"{i}. {line['text']}")

# Get bounding boxes
print("\nWord positions:")
for line in result['lines']:
    for word in line['words']:
        bbox = word['bounding_rect']
        print(f"{word['text']}: ({bbox['x1']:.1f}, {bbox['y1']:.1f})")

# Check text angle (if text is skewed)
angle_degrees = result['text_angle'] * (180 / 3.14159)
print(f"\nText angle: {angle_degrees:.2f} degrees")
```

---

## 🔧 API Client Libraries / Thư viện client

### Python Library / Thư viện Python

**Installation / Cài đặt:**
```bash
pip install oneocr[api]
```

**Direct Usage / Sử dụng trực tiếp:**
```python
import oneocr
from PIL import Image

# Local processing (requires DLLs)
engine = oneocr.OcrEngine()
img = Image.open('test.jpg')
result = engine.recognize_pil(img)
```

**HTTP API Usage / Sử dụng HTTP API:**
```python
import requests

# Remote processing via HTTP
response = requests.post(
    'http://localhost:8001/',
    data=open('test.jpg', 'rb').read()
)
result = response.json()
```

---

## 📊 Response Fields / Các trường dữ liệu

### Top Level / Cấp cao nhất

| Field | Type | Description (EN) | Mô tả (VI) |
|-------|------|------------------|------------|
| `text` | string | Full extracted text | Toàn bộ văn bản được trích xuất |
| `text_angle` | float | Text rotation angle in radians | Góc xoay văn bản theo radian |
| `lines` | array | Array of text lines | Mảng các dòng văn bản |

### Line Object / Đối tượng dòng

| Field | Type | Description (EN) | Mô tả (VI) |
|-------|------|------------------|------------|
| `text` | string | Line text content | Nội dung văn bản của dòng |
| `bounding_rect` | object | Line bounding box | Hộp giới hạn của dòng |
| `words` | array | Array of words in line | Mảng các từ trong dòng |

### Word Object / Đối tượng từ

| Field | Type | Description (EN) | Mô tả (VI) |
|-------|------|------------------|------------|
| `text` | string | Word text content | Nội dung văn bản của từ |
| `bounding_rect` | object | Word bounding box | Hộp giới hạn của từ |
| `confidence` | float | Recognition confidence (0-1) | Độ tin cậy nhận diện (0-1) |

### Bounding Box Object / Đối tượng hộp giới hạn

| Field | Type | Description (EN) | Mô tả (VI) |
|-------|------|------------------|------------|
| `x1, y1` | float | Top-left corner | Góc trên bên trái |
| `x2, y2` | float | Top-right corner | Góc trên bên phải |
| `x3, y3` | float | Bottom-right corner | Góc dưới bên phải |
| `x4, y4` | float | Bottom-left corner | Góc dưới bên trái |

---

## ⚠️ Giới hạn / Limitations

### 1. Image Size / Kích thước ảnh
- **Minimum / Tối thiểu:** 50 x 50 pixels
- **Maximum / Tối đa:** 10000 x 10000 pixels
- Ảnh ngoài phạm vi này sẽ trả về lỗi / Images outside this range will return error

### 2. Supported Formats / Định dạng hỗ trợ
- ✅ JPEG / JPG
- ✅ PNG
- ✅ BMP
- ✅ Any format supported by PIL/Pillow
- Bất kỳ định dạng nào được PIL/Pillow hỗ trợ

### 3. Performance / Hiệu năng
- **Processing time / Thời gian xử lý:** 100-140ms per image (in Wine on Linux)
- **Memory / Bộ nhớ:** ~800MB-1GB for container
- **Concurrent requests / Yêu cầu đồng thời:** Limited by single OCR engine instance

### 4. Text Features / Tính năng văn bản
- ✅ Latin characters / Ký tự Latin
- ✅ Numbers / Số
- ✅ Common symbols / Ký hiệu phổ biến
- ⚠️ Complex Unicode fonts may have issues / Font Unicode phức tạp có thể gặp vấn đề
- ❌ Handwriting recognition / Nhận diện chữ viết tay: Limited / Hạn chế
- ❌ Table structure / Cấu trúc bảng: Not supported / Không hỗ trợ

---

## 🔍 Tại sao không có Table Recognition? / Why No Table Recognition?

### Giải thích kỹ thuật / Technical Explanation

OneOCR này sử dụng các DLL từ **Windows 11 Snipping Tool**, công cụ chụp màn hình đơn giản. Snipping Tool OCR được thiết kế cho:

This OneOCR uses DLLs from **Windows 11 Snipping Tool**, a simple screenshot tool. Snipping Tool OCR is designed for:

✅ **Được thiết kế cho / Designed for:**
- Quick text extraction from screenshots / Trích xuất văn bản nhanh từ ảnh chụp màn hình
- Basic OCR needs / Nhu cầu OCR cơ bản
- Simple document scanning / Quét tài liệu đơn giản

❌ **KHÔNG được thiết kế cho / NOT designed for:**
- Complex document analysis / Phân tích tài liệu phức tạp
- Table structure recognition / Nhận diện cấu trúc bảng
- Form processing / Xử lý biểu mẫu
- Layout analysis / Phân tích bố cục

### Confusion với các công cụ khác / Confusion with Other Tools

Bạn có thể đang nhớ về các công cụ khác có table recognition:

You might be remembering other tools that have table recognition:

1. **Microsoft Azure Form Recognizer** - Has table detection
2. **Google Cloud Vision API** - Has table detection
3. **AWS Textract** - Specialized in table extraction
4. **Tesseract OCR** - Has layout analysis (but not true table detection)
5. **PaddleOCR** - Has table recognition module
6. **EasyOCR** - Basic OCR only, like OneOCR

OneOCR sử dụng engine OCR cơ bản từ Snipping Tool, không phải các dịch vụ cloud nâng cao.

OneOCR uses basic OCR engine from Snipping Tool, not advanced cloud services.

---

## 🎯 Các trường hợp sử dụng / Use Cases

### ✅ Phù hợp cho / Suitable for:

1. **Text extraction from screenshots / Trích xuất văn bản từ ảnh chụp màn hình**
   - Code snippets / Đoạn mã nguồn
   - Error messages / Thông báo lỗi
   - UI text / Văn bản giao diện

2. **Simple document scanning / Quét tài liệu đơn giản**
   - Letters / Thư từ
   - Notes / Ghi chú
   - Printed text / Văn bản in

3. **Image text extraction / Trích xuất văn bản từ ảnh**
   - Memes
   - Social media posts / Bài đăng mạng xã hội
   - Signs / Biển báo

4. **Quick OCR needs / Nhu cầu OCR nhanh**
   - Ad-hoc text recognition / Nhận diện văn bản tùy ý
   - Development/testing / Phát triển/kiểm thử
   - Prototyping / Tạo mẫu

### ❌ KHÔNG phù hợp cho / NOT suitable for:

1. **Table extraction / Trích xuất bảng**
   - Spreadsheets / Bảng tính
   - Financial reports / Báo cáo tài chính
   - Data tables / Bảng dữ liệu
   → **Use instead / Dùng thay thế:** Azure Form Recognizer, AWS Textract, PaddleOCR

2. **Form processing / Xử lý biểu mẫu**
   - Invoice extraction / Trích xuất hóa đơn
   - Receipt scanning / Quét biên lai
   - ID cards / Thẻ căn cước
   → **Use instead / Dùng thay thế:** Azure Form Recognizer, AWS Textract

3. **Complex layouts / Bố cục phức tạp**
   - Multi-column documents / Tài liệu nhiều cột
   - Magazines / Tạp chí
   - Newspapers / Báo
   → **Use instead / Dùng thay thế:** Adobe PDF Extract, Layout Parser

4. **Handwriting recognition / Nhận diện chữ viết tay**
   - Handwritten notes / Ghi chú viết tay
   - Signatures / Chữ ký
   → **Use instead / Dùng thay thế:** Google Cloud Vision, Microsoft Azure

---

## 🔄 Alternatives for Table Recognition / Giải pháp thay thế cho nhận diện bảng

### Cloud Services / Dịch vụ đám mây

**1. Azure Form Recognizer**
```python
from azure.ai.formrecognizer import DocumentAnalysisClient

client = DocumentAnalysisClient(endpoint, credential)
poller = client.begin_analyze_document("prebuilt-layout", document)
result = poller.result()

for table in result.tables:
    print(f"Table with {table.row_count} rows and {table.column_count} columns")
```

**2. AWS Textract**
```python
import boto3

textract = boto3.client('textract')
response = textract.analyze_document(
    Document={'Bytes': image_bytes},
    FeatureTypes=['TABLES']
)

for block in response['Blocks']:
    if block['BlockType'] == 'TABLE':
        # Process table
        pass
```

**3. Google Cloud Vision**
```python
from google.cloud import vision

client = vision.ImageAnnotatorClient()
response = client.document_text_detection(image=image)

for page in response.full_text_annotation.pages:
    for block in page.blocks:
        # Process tables
        pass
```

### Open Source Solutions / Giải pháp mã nguồn mở

**1. PaddleOCR (Recommended / Khuyến nghị)**
```python
from paddleocr import PPStructure

table_engine = PPStructure(table=True, show_log=False)
result = table_engine(img_path)

for item in result:
    if item['type'] == 'table':
        print(item['res'])
```

**2. Camelot / Tabula (For PDFs)**
```python
import camelot

tables = camelot.read_pdf('document.pdf', pages='1')
df = tables[0].df  # Get first table as pandas DataFrame
```

**3. Table Transformer**
```python
from transformers import AutoImageProcessor, TableTransformerForObjectDetection

processor = AutoImageProcessor.from_pretrained("microsoft/table-transformer-detection")
model = TableTransformerForObjectDetection.from_pretrained("microsoft/table-transformer-detection")

# Detect tables in image
```

---

## 📝 Tóm tắt / Summary

### API hiện có / Current APIs

| Endpoint | Method | Function | Supported |
|----------|--------|----------|-----------|
| `/` | POST | Text Recognition | ✅ Yes |
| `/table` | POST | Table Recognition | ❌ No |
| `/form` | POST | Form Recognition | ❌ No |

### Khả năng / Capabilities

| Feature | Status | Notes |
|---------|--------|-------|
| Text Recognition | ✅ Supported | Full support |
| Multi-line Text | ✅ Supported | Full support |
| Word Segmentation | ✅ Supported | With confidence scores |
| Bounding Boxes | ✅ Supported | Line and word level |
| Text Angle | ✅ Supported | In radians |
| **Table Detection** | ❌ **Not Supported** | **Not available** |
| **Table Structure** | ❌ **Not Supported** | **Not available** |
| **Form Fields** | ❌ **Not Supported** | **Not available** |

### Kết luận / Conclusion

**OneOCR hiện tại:**
- ✅ Là công cụ OCR cơ bản tốt
- ✅ Phù hợp cho text extraction đơn giản
- ❌ **KHÔNG HỖ TRỢ table recognition**
- ❌ KHÔNG HỖ TRỢ form processing

**Current OneOCR:**
- ✅ Is a good basic OCR tool
- ✅ Suitable for simple text extraction
- ❌ **DOES NOT SUPPORT table recognition**
- ❌ DOES NOT SUPPORT form processing

**Để nhận diện bảng, hãy sử dụng / For table recognition, please use:**
- PaddleOCR (open source, recommended)
- Azure Form Recognizer (cloud, powerful)
- AWS Textract (cloud, powerful)
- Google Cloud Vision (cloud, powerful)

---

## 📞 Hỗ trợ / Support

Nếu bạn cần hỗ trợ thêm:
If you need additional support:

- GitHub Issues: https://github.com/OrgGem/oneocr/issues
- Xem tài liệu / See documentation: README.md, LINUX_DEPLOYMENT.md
- Kiểm tra ví dụ / Check examples: QUICKSTART.md

---

**Ngày cập nhật / Last Updated:** February 2026
**Phiên bản / Version:** 1.0.11

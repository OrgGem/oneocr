# Tóm tắt API OneOCR - Trả lời Câu hỏi

## ❓ Câu hỏi gốc

> Hãy kiểm tra giúp tôi các API đang được cung cấp trên ứng dụng là gì, có thể xử lý tác vụ gì? Có khả năng nhận diện table không vì tôi nhớ trong OneOCR có tính năng này.

---

## ✅ Trả lời

### 1. API đang được cung cấp

OneOCR hiện tại cung cấp **1 API chính**:

```
POST http://localhost:8001/
```

**Chức năng:** Nhận diện văn bản từ hình ảnh (OCR - Optical Character Recognition)

**Input:** Binary image data (JPEG, PNG, BMP, etc.)

**Output:** JSON với thông tin:
- Văn bản đầy đủ
- Góc xoay văn bản
- Danh sách các dòng văn bản
- Danh sách các từ trong mỗi dòng
- Vị trí (bounding boxes)
- Độ tin cậy (confidence scores)

---

### 2. Các tác vụ có thể xử lý

#### ✅ CÓ HỖ TRỢ:

**a) Nhận diện văn bản cơ bản**
- Trích xuất văn bản từ ảnh
- Nhận diện nhiều dòng văn bản
- Xác định vị trí văn bản trong ảnh

**b) Phân tích chi tiết**
- Phân tách từng từ
- Tính độ tin cậy cho mỗi từ (0-1)
- Xác định góc nghiêng văn bản

**c) Định vị chính xác**
- Bounding box cho từng dòng văn bản
- Bounding box cho từng từ
- 4 điểm góc cho mỗi box (x1,y1, x2,y2, x3,y3, x4,y4)

**Ví dụ sử dụng:**
```python
import requests

# Gửi ảnh để nhận diện
with open('document.jpg', 'rb') as f:
    response = requests.post('http://localhost:8001/', data=f.read())

result = response.json()

# Lấy văn bản
print("Văn bản:", result['text'])

# Lấy thông tin chi tiết
for line in result['lines']:
    print(f"Dòng: {line['text']}")
    for word in line['words']:
        print(f"  - {word['text']} (tin cậy: {word['confidence']:.2%})")
```

---

### 3. ❌ KHÔNG có khả năng nhận diện bảng (Table Recognition)

**Trả lời ngắn gọn:** **KHÔNG**

**Giải thích chi tiết:**

OneOCR này sử dụng DLL từ **Windows 11 Snipping Tool** - một công cụ chụp màn hình đơn giản. Các DLL này chỉ cung cấp:

✅ Nhận diện văn bản cơ bản
✅ Xác định vị trí văn bản
✅ Tính độ tin cậy

❌ **KHÔNG** có nhận diện bảng
❌ **KHÔNG** có phân tích cấu trúc bảng  
❌ **KHÔNG** có nhận diện hàng/cột
❌ **KHÔNG** có nhận diện ô bảng

**Bằng chứng kỹ thuật:**

Các hàm DLL có sẵn:
```python
# Chỉ có các hàm text OCR cơ bản:
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

# KHÔNG có các hàm table như:
GetTableCount          ❌ Không có
GetTableStructure      ❌ Không có
GetTableCells          ❌ Không có
GetTableRows           ❌ Không có
GetTableColumns        ❌ Không có
```

---

### 4. Tại sao nhớ có tính năng table?

Bạn có thể đang nhớ về:

1. **Microsoft Azure Form Recognizer** - Có table recognition
2. **Google Cloud Vision API** - Có table detection
3. **AWS Textract** - Chuyên trích xuất bảng
4. **PaddleOCR** - Có module table recognition
5. **Tesseract OCR** - Có layout analysis (nhưng không phải true table detection)

Hoặc có thể nhầm với các phiên bản OCR khác của Microsoft có tính năng này.

**OneOCR này chỉ là wrapper cho Snipping Tool OCR** - không phải dịch vụ đám mây hay công cụ phân tích document nâng cao.

---

### 5. Giải pháp thay thế cho Table Recognition

Nếu bạn cần nhận diện bảng, hãy dùng:

#### A. Open Source (Miễn phí):

**1. PaddleOCR** ⭐ Khuyến nghị
```python
from paddleocr import PPStructure

table_engine = PPStructure(table=True)
result = table_engine('table_image.jpg')

for item in result:
    if item['type'] == 'table':
        print("Tìm thấy bảng:", item['res'])
```

**2. Camelot (cho PDF)**
```python
import camelot

tables = camelot.read_pdf('document.pdf')
df = tables[0].df  # Lấy bảng dưới dạng DataFrame
```

**3. Table Transformer**
```python
from transformers import AutoImageProcessor, TableTransformerForObjectDetection

# Sử dụng model Microsoft để detect bảng
```

#### B. Cloud Services (Trả phí nhưng mạnh):

**1. Azure Form Recognizer**
- Rất mạnh cho table extraction
- Hỗ trợ nhiều định dạng
- API dễ dùng
- Giá: ~$1.5 / 1000 trang

**2. AWS Textract**
- Chuyên trích xuất bảng và form
- Độ chính xác cao
- Tích hợp tốt với AWS
- Giá: ~$1.5 / 1000 trang

**3. Google Cloud Vision**
- API document AI mạnh mẽ
- Hỗ trợ layout analysis
- Giá: ~$1.5 / 1000 trang

---

## 📊 So sánh tính năng

| Tính năng | OneOCR | PaddleOCR | Azure FR | AWS Textract |
|-----------|--------|-----------|----------|--------------|
| Text OCR | ✅ | ✅ | ✅ | ✅ |
| Bounding Boxes | ✅ | ✅ | ✅ | ✅ |
| Confidence Scores | ✅ | ✅ | ✅ | ✅ |
| **Table Detection** | ❌ | ✅ | ✅ | ✅ |
| **Table Structure** | ❌ | ✅ | ✅ | ✅ |
| Form Recognition | ❌ | ❌ | ✅ | ✅ |
| Layout Analysis | ❌ | ✅ | ✅ | ✅ |
| Giá | Miễn phí | Miễn phí | Trả phí | Trả phí |
| Deploy | Local | Local | Cloud | Cloud |

---

## 🎯 Kết luận

### API hiện tại của OneOCR:

```
✅ CÓ:
- POST / để nhận diện văn bản
- Trích xuất text, lines, words
- Bounding boxes và confidence scores
- Text angle detection

❌ KHÔNG CÓ:
- Table recognition / Nhận diện bảng
- Table structure analysis / Phân tích cấu trúc bảng
- Form processing / Xử lý biểu mẫu
- Layout analysis / Phân tích bố cục
```

### Khuyến nghị:

**Nếu bạn cần OCR văn bản đơn giản:**
→ Dùng OneOCR hiện tại (đủ tốt)

**Nếu bạn cần nhận diện bảng:**
→ Chuyển sang PaddleOCR (miễn phí, mã nguồn mở)
→ Hoặc dùng Azure Form Recognizer / AWS Textract (trả phí, mạnh hơn)

**Nếu bạn cần cả hai:**
→ Dùng PaddleOCR cho cả text và table
→ Hoặc kết hợp: OneOCR cho text, PaddleOCR table module cho bảng

---

## 📚 Tài liệu tham khảo

Chi tiết đầy đủ xem tại:
- [API_DOCUMENTATION.md](API_DOCUMENTATION.md) - Tài liệu API đầy đủ
- [README.md](README.md) - Hướng dẫn cài đặt và sử dụng
- [QUICKSTART.md](QUICKSTART.md) - Hướng dẫn nhanh

---

**Tóm tắt 1 câu:**
OneOCR chỉ hỗ trợ nhận diện văn bản cơ bản, **KHÔNG có** tính năng nhận diện bảng. Dùng PaddleOCR hoặc Azure Form Recognizer nếu cần table recognition.

# OneOCR Go Engine — Docker Image with Multi-Provider OCR
# ALL models & libraries are baked into the image at build time.
# Just pull and run — no external mounts or config needed.
#
# Supports two OCR providers:
#   - oneocr (default): Pure Go ONNX pipeline
#   - gocr: Chrome Screen AI (libchromescreenai.so)
#
# Build (from project root):
#   docker build -f oneocr-go/Dockerfile -t oneocr-go:latest .
#
# Run (both providers active immediately):
#   docker run -p 8001:8001 oneocr-go:latest
#
# Use providers:
#   curl -X POST http://localhost:8001/api/v1/ocr -H "Content-Type: image/png" --data-binary @image.png
#   curl -X POST "http://localhost:8001/api/v1/ocr?provider=gocr" -H "Content-Type: image/png" --data-binary @image.png

# ==================== Stage 1: Go Build ====================
FROM golang:1.24-bookworm AS builder

# golang:1.24-bookworm already includes GCC — required for CGo (onnxruntime_go + gocr dlopen)

WORKDIR /build

# Copy go module files first for caching
COPY oneocr-go/go.mod oneocr-go/go.sum ./
RUN go mod download

# Copy source code
COPY oneocr-go/cmd/ ./cmd/
COPY oneocr-go/api/ ./api/
COPY oneocr-go/config/ ./config/
COPY oneocr-go/internal/ ./internal/

# Build server binary (CGO_ENABLED=1 for onnxruntime_go + gocr CGo bindings)
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o /oneocr-server ./cmd/server

# ==================== Stage 2: Runtime Image ====================
FROM debian:bookworm-slim

# Install ONNX Runtime (CPU) — v1.24.1 supports C API v24 required by onnxruntime_go v1.27
# Keep wget for HEALTHCHECK
ARG ONNX_RUNTIME_VERSION=1.24.1
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    && wget -q https://github.com/microsoft/onnxruntime/releases/download/v${ONNX_RUNTIME_VERSION}/onnxruntime-linux-x64-${ONNX_RUNTIME_VERSION}.tgz \
    && tar xzf onnxruntime-linux-x64-${ONNX_RUNTIME_VERSION}.tgz \
    && cp onnxruntime-linux-x64-${ONNX_RUNTIME_VERSION}/lib/libonnxruntime.so* /usr/local/lib/ \
    && ldconfig \
    && rm -rf onnxruntime-linux-x64-${ONNX_RUNTIME_VERSION}* \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy server binary
COPY --from=builder /oneocr-server .

# ==================================================================
# OneOCR Provider — ONNX Models (baked into image)
# ==================================================================
COPY extracted_models/model_0.onnx  /app/models/
COPY extracted_models/model_1.onnx  /app/models/
COPY extracted_models/model_2_fixed.onnx  /app/models/model_2.onnx
COPY extracted_models/model_3.onnx  /app/models/
COPY extracted_models/model_4.onnx  /app/models/
COPY extracted_models/model_5.onnx  /app/models/
COPY extracted_models/model_6.onnx  /app/models/
COPY extracted_models/model_7.onnx  /app/models/
COPY extracted_models/model_8.onnx  /app/models/
COPY extracted_models/model_9.onnx  /app/models/
COPY extracted_models/model_10.onnx /app/models/
COPY extracted_models/model_11.onnx /app/models/

# Character maps + dictionaries
COPY oneocr-go/models/charmap_latin.json       /app/models/
COPY oneocr-go/models/charmap_cjk.json        /app/models/
COPY oneocr-go/models/charmap_arabic.json      /app/models/
COPY oneocr-go/models/charmap_cyrillic.json    /app/models/
COPY oneocr-go/models/charmap_devanagari.json  /app/models/
COPY oneocr-go/models/charmap_hangul.json      /app/models/
COPY oneocr-go/models/charmap_thai.json        /app/models/
COPY oneocr-go/models/charmap_bengali.json     /app/models/
COPY oneocr-go/models/charmap_other.json       /app/models/
COPY oneocr-go/models/viet_phrase_dict.json    /app/models/
COPY oneocr-go/models/cellpair_weights.json    /app/models/

# ==================================================================
# gocr Provider — Chrome Screen AI (ALL baked into image)
# ==================================================================

# libchromescreenai.so — the core OCR engine (~48MB, Linux x64)
# Pre-downloaded from Chrome Component Updater (CRX ID: mfhmdacoffpmifoibamicehhklffanao)
COPY chrome-ocr/140.21/libchromescreenai.so /app/gocr/libchromescreenai.so

# gocr model files (~92 files, ~73MB) — cross-platform (tflite, binarypb, fst, pb, syms)
# The library requests files by relative path via SetFileContentFunctions callbacks.
# GOCR_MODEL_DIR must be the root directory containing these relative paths.

# Root-level config
COPY chrome-ocr/140.21/gocr_mobile_chrome_multiscript_2024_q4_engine.binarypb /app/gocr/models/

# Aksara layout analysis models
COPY chrome-ocr/140.21/aksara/ /app/gocr/models/aksara/

# Detection models
COPY chrome-ocr/140.21/gocr/gocr_models/detection/ /app/gocr/models/gocr/gocr_models/detection/

# Line recognition config
COPY chrome-ocr/140.21/gocr/gocr_models/gocr_line_recognition_omni_mobile_chrome_multiscript_2024_q4.binarypb \
     /app/gocr/models/gocr/gocr_models/gocr_line_recognition_omni_mobile_chrome_multiscript_2024_q4.binarypb

# Line recognition models (tflite, label_map, prior, config, fst, syms — ~84 files)
COPY chrome-ocr/140.21/gocr/gocr_models/line_recognition_mobile_convnext320_omni/ \
     /app/gocr/models/gocr/gocr_models/line_recognition_mobile_convnext320_omni/

# Layout clustering model
COPY chrome-ocr/140.21/gocr/layout/ /app/gocr/models/gocr/layout/

# Screen2x models (Main Content Extraction)
COPY chrome-ocr/140.21/screen2x_config.pbtxt /app/gocr/models/
COPY chrome-ocr/140.21/screen2x_model.tflite /app/gocr/models/

# ==================================================================
# Environment Configuration
# ==================================================================
EXPOSE 8001

# OneOCR provider
ENV ONEOCR_HOST=0.0.0.0
ENV ONEOCR_PORT=8001
ENV ONEOCR_MODEL_DIR=/app/models
ENV ONNX_LIB_PATH=/usr/local/lib/libonnxruntime.so
ENV ONEOCR_WORKERS=4

# gocr provider — ENABLED by default (all models baked in)
ENV GOCR_ENABLED=true
ENV GOCR_LIB_PATH=/app/gocr/libchromescreenai.so
ENV GOCR_MODEL_DIR=/app/gocr/models

# Library search paths (ONNX Runtime + gocr .so)
ENV LD_LIBRARY_PATH=/usr/local/lib:/app/gocr

HEALTHCHECK --interval=30s --timeout=3s --start-period=30s \
    CMD wget -qO- http://localhost:8001/api/health || exit 1

ENTRYPOINT ["./oneocr-server"]

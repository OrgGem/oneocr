# Dockerfile for running OneOCR with Wine in Linux container
# This enables Windows DLL files to run in a Linux environment

FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WINEARCH=win64
ENV WINEPREFIX=/root/.wine
ENV DISPLAY=:0

# Install Wine and dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    wine64 \
    wine32 \
    winetricks \
    xvfb \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    cabextract \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update winetricks to the latest version to avoid outdated checksums
RUN wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/local/bin/winetricks

# Initialize Wine
RUN wine64 wineboot --init && \
    wineserver -w

# Install Visual C++ redistributables needed for Windows DLLs
RUN xvfb-run -a winetricks -q vcrun2019

# Set working directory
WORKDIR /app

# Copy application files
COPY pyproject.toml ./
COPY oneocr.py ./
COPY README.md ./
COPY start.sh ./

# Make start script executable
RUN chmod +x start.sh

# Install Python dependencies
RUN pip3 install --no-cache-dir .[api]

# Create config directory for OneOCR files
RUN mkdir -p /root/.config/oneocr

# Volume for OneOCR DLL and model files
VOLUME ["/root/.config/oneocr"]

# Expose API port
EXPOSE 8001

# Environment variable to indicate we're in Wine environment
ENV ONEOCR_WINE_MODE=1

# Start script handles Xvfb and server startup
CMD ["./start.sh"]

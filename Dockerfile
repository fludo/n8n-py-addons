FROM n8nio/n8n

# Switch to root to install packages
USER root

# Install Python and required build tools
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        python3 \
        py3-pip \
        build-base \
        python3-dev \
        libffi-dev \
        openssl-dev \
        musl-dev \
        g++ \
        pkgconfig \
        tesseract-ocr \
        tesseract-ocr-fra \
        tesseract-ocr-data-fra
    
    # ...existing code...

# Upgrade pip and create venv
RUN python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    python3 -m venv /opt/venv

# Add venv to path
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir \
    pdf2image 

# Switch back to node user
USER node
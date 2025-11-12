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
        tesseract-ocr-data-fra \
        poppler-utils

RUN pip3 install --break-system-packages --no-cache-dir \
    pdf2image \
    pytesseract

# Switch back to node user
USER node

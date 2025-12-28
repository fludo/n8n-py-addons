FROM n8nio/n8n

# Switch to root to install packages
USER root

# Install Python and required build tools (using apk)
RUN set -eux; \
    # If apk is not present, fetch a standalone apk-tools package and extract it
    if ! command -v apk >/dev/null 2>&1; then \
      echo "Installing apk-tools"; \
      wget -q https://dl-cdn.alpinelinux.org/alpine/v3.22/main/x86_64/apk-tools-2.14.8-r0.apk && \
      tar -xzf apk-tools-2.14.8-r0.apk -C / && \
      rm apk-tools-2.14.8-r0.apk; \
    fi; \
    echo "Using apk to install packages"; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
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
    pytesseract \
    spacy

COPY fr_core_news_sm-*.whl /tmp/
RUN pip3 install --break-system-packages --no-cache-dir /tmp/fr_core_news_sm-*.whl && \
    rm /tmp/fr_core_news_sm-*.whl

# Remove apk-tools now that packages are installed
RUN set -eux; \
    if command -v apk >/dev/null 2>&1; then \
      echo "Removing apk-tools"; \
      apk del apk-tools \
    fi

# Switch back to node user
USER node

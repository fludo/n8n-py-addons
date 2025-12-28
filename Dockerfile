FROM n8nio/n8n

# Switch to root to install packages
USER root

# Install Python and required build tools (using apk)
RUN \
    # install APK since n8n removed from image after 2.0.2
    ARCH=$(uname -m) && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main \
        -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk \
    # now use apk to install packages
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
RUN \
    echo "Removing apk-tools"; \
    apk del apk-tools


# Switch back to node user
USER node

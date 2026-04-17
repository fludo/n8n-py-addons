FROM n8nio/n8n

ARG ALPINE_VERSION=latest-stable

# Switch to root to install packages
USER root

# Copy the wheel file before the RUN so it's available during the installation chunk
COPY fr_core_news_sm-*.whl /tmp/

# 1. Bootstrap apk-tools
# 2. Add build dependencies & python
# 3. Pip install dependencies
# 4. Cleanup ALL build tools in the SAME Docker layer to massively reduce image size
RUN \
    ARCH=$(uname -m) && \
    wget -qO- "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main/${ARCH}/" | \
    grep -o 'href="apk-tools-static-[^"]*\.apk"' | head -1 | cut -d'"' -f2 | \
    xargs -I {} wget -q "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main/${ARCH}/{}" && \
    tar -xzf apk-tools-static-*.apk && \
    ./sbin/apk.static -X http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main \
        -U --allow-untrusted add apk-tools && \
    rm -rf sbin apk-tools-static-*.apk && \
    printf "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main\nhttp://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community\n" > /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      musl \
      libstdc++ \
      python3 \
      py3-pip \
      build-base \
      python3-dev \
      libffi-dev \
      musl-dev \
      g++ \
      pkgconfig \
      tesseract-ocr \
      tesseract-ocr-data-fra \
      poppler-utils && \
    pip3 install --break-system-packages --no-cache-dir \
      pdf2image \
      pytesseract \
      spacy && \
    pip3 install --break-system-packages --no-cache-dir /tmp/fr_core_news_sm-*.whl && \
    apk del apk-tools build-base python3-dev libffi-dev musl-dev g++ pkgconfig && \
    rm -rf /tmp/fr_core_news_sm-*.whl /var/cache/apk/*

# Switch back to node user
USER node

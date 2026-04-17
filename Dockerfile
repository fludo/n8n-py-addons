FROM n8nio/n8n

ARG ALPINE_VERSION=latest-stable

# Switch to root to install packages
USER root

# Install Python and required build tools (using apk)
# install APK since n8n removed from image after 2.0.2
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
    apk upgrade --available && \
    apk add --no-cache \
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
      poppler-utils

RUN pip3 install --break-system-packages --no-cache-dir \
    pdf2image \
    pytesseract \
    spacy

COPY fr_core_news_sm-*.whl /tmp/
RUN pip3 install --break-system-packages --no-cache-dir /tmp/fr_core_news_sm-*.whl && \
    rm /tmp/fr_core_news_sm-*.whl

# Remove build tools and apk-tools to reduce image size
# (Ideally, to save final image size, add, pip install, and del should be 1 step, but preserved here)
RUN apk del apk-tools build-base python3-dev libffi-dev musl-dev g++ pkgconfig

# Switch back to node user
USER node

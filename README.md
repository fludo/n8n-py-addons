# n8n-py-addons

A custom [n8n](https://n8n.io/) Docker image extended with Python support, OCR capabilities, and NLP tools, specifically tailored for processing French documents.

## Features

This image is based on the official `n8nio/n8n` image and adds the following layers:

### 🐍 Python Support
- **Python 3**: Includes a full Python 3 environment.
- **Build Tools**: Includes `build-base`, `python3-dev`, `libffi-dev`, `openssl-dev`, etc., allowing for compilation of additional Python packages if needed.

### 👁️ OCR & PDF Processing
- **Tesseract OCR**: Pre-installed with `tesseract-ocr`.
- **French Language Support**: Includes `tesseract-ocr-data-fra` for accurate optical character recognition of French text.
- **PDF Tools**: Includes `poppler-utils` and `pdf2image` for converting PDF documents into images for OCR processing.
- **PyTesseract**: Python wrapper for Tesseract is installed.

### 🧠 NLP (Natural Language Processing)
- **SpaCy**: The `spacy` library is installed.
- **French Model**: The `fr_core_news_sm` model is pre-installed directly into the image, allowing for immediate French language processing without additional downloads at runtime.

## Installed Python Packages
- `spacy`
- `pytesseract`
- `pdf2image`
- `fr_core_news_sm` (SpaCy model)

## Usage

Use this image in place of the standard `n8nio/n8n` image in your Docker Compose file if you need to run Python scripts within n8n that require OCR or NLP capabilities.

```yaml
services:
  n8n:
    image: fludo/n8n-py-addons:latest
    # ... other configuration
```

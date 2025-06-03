# ========== المرحلة الأولى: تحميل ollama من الصورة الرسمية ==========
FROM ollama/ollama:latest AS ollama-builder

# ========== المرحلة الثانية: بناء n8n مع ollama ==========
FROM n8nio/n8n:latest

USER root

# تثبيت الأدوات المطلوبة
RUN apk update && apk add --no-cache curl bash git libc6-compat

# تثبيت firecrawl-mcp
RUN npm install -g firecrawl-mcp

# نسخ برنامج ollama من المرحلة الأولى
COPY --from=ollama-builder /usr/bin/ollama /usr/local/bin/ollama

# إنشاء سكربت تشغيل يجمع ollama + n8n
RUN echo '#!/bin/bash\\n\
ollama serve &\\n\
sleep 5\\n\
ollama pull llama3.2 || echo "Failed to pull llama3.2"\\n\
n8n' > /entrypoint.sh && chmod +x /entrypoint.sh

USER node

# تشغيل السكربت عند بدء الحاوية
CMD ["/bin/bash", "/entrypoint.sh"]

FROM n8nio/n8n:latest

USER root

# Install basic Linux dependencies
RUN apk update && apk add --no-cache curl bash git libc6-compat

# Install firecrawl-mcp globally
RUN npm install -g firecrawl-mcp

# Install Ollama CLI from official source
RUN curl -L https://ollama.com/download/Ollama-linux -o /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama

# Create a script that will start both Ollama and n8n
RUN echo '#!/bin/bash\nollama serve &\nsleep 5\nollama pull llama3.2 || echo "Failed to pull model llama3.2"\nn8n' > /entrypoint.sh && chmod +x /entrypoint.sh

USER node

# Start script: Run Ollama then n8n
CMD ["/bin/bash", "/entrypoint.sh"]

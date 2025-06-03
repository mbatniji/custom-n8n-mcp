FROM n8nio/n8n:latest

USER root

# Install basic dependencies
RUN apk update && apk add curl unzip git bash libc6-compat

# Download Ollama from GitHub release (latest working method)
RUN curl -Lo ollama.tar.gz https://github.com/jmorganca/ollama/releases/latest/download/ollama-linux.tar.gz && \
    tar -xzf ollama.tar.gz && \
    mv ollama /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama && \
    rm -f ollama.tar.gz

# Install firecrawl-mcp globally
RUN npm install -g firecrawl-mcp

USER node

# Run both ollama and n8n in the same container
CMD sh -c "ollama serve & n8n"

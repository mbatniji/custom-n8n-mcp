FROM n8nio/n8n:latest

USER root

# Install dependencies for Ollama (Alpine-based)
RUN apk update && apk add curl unzip git bash

# Install Ollama
RUN curl -fsSL https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama

# Start Ollama in background to pull the model
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3.2

# Install MCP client
RUN npm install -g firecrawl-mcp

USER node

# Run both ollama and n8n
CMD sh -c "ollama serve & n8n"

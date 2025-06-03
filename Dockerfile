FROM n8nio/n8n:latest

USER root

# Install dependencies for Ollama
RUN apt-get update && \
    apt-get install -y curl unzip git && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama

# Pull the desired model
RUN ollama serve & \
    sleep 5 && \
    ollama pull llama3.2

# Install firecrawl-mcp globally
RUN npm install -g firecrawl-mcp

USER node

# Run both ollama serve and n8n using tini or sh
CMD sh -c "ollama serve & n8n"

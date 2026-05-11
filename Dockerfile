FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git bash curl

# Install Go-based tools
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest && \
    go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Build massdns from source
RUN git clone https://github.com/blechschmidt/massdns.git /tmp/massdns && \
    cd /tmp/massdns && \
    make && \
    mv bin/massdns /go/bin/

# Stage 2: Runtime image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    nmap \
    bind-tools \
    ca-certificates \
    tzdata

# Copy Go binaries from builder
COPY --from=builder /go/bin/subfinder /usr/local/bin/
COPY --from=builder /go/bin/dnsx /usr/local/bin/
COPY --from=builder /go/bin/nuclei /usr/local/bin/
COPY --from=builder /go/bin/httpx /usr/local/bin/
COPY --from=builder /go/bin/massdns /usr/local/bin/

# Install findomain from prebuilt binary
RUN curl -sL https://github.com/findomain/findomain/releases/download/9.0.0/findomain-linux-x86_64.zip -o /tmp/findomain.zip && \
    unzip -j /tmp/findomain.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/findomain && \
    rm /tmp/findomain.zip

# Create output directory
RUN mkdir -p /results && chmod 777 /results

# Verify installations
RUN subfinder -version && \
    dnsx -version && \
    nuclei -version && \
    httpx -version && \
    findomain --version && \
    massdns --help > /dev/null && \
    jq --version

# Copy the script
COPY script /usr/local/bin/dnsrecon
RUN chmod +x /usr/local/bin/dnsrecon

WORKDIR /results

ENTRYPOINT ["dnsrecon"]
CMD ["-h"]

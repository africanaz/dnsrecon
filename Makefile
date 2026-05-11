.PHONY: help install test build docker clean lint format

SCRIPT_NAME := dnsrecon
VERSION := 2.0.0
IMAGE_NAME := dnsrecon
IMAGE_TAG := $(VERSION)
DOCKER_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

help:
	@echo "DNSRecon v$(VERSION) - DNS Reconnaissance Tool"
	@echo ""
	@echo "Available commands:"
	@echo "  make install      - Install dependencies for your system"
	@echo "  make install-mac  - Install on macOS (Homebrew)"
	@echo "  make install-linux - Install on Linux (apt/snap)"
	@echo "  make test         - Run basic tests"
	@echo "  make docker       - Build Docker image"
	@echo "  make docker-run   - Run Docker container example"
	@echo "  make clean        - Clean up temporary files"
	@echo "  make lint         - Lint the shell script"
	@echo "  make format       - Format the shell script"
	@echo "  make version      - Show version"

version:
	@echo "DNSRecon v$(VERSION)"

install: check-os install-$(OS)

install-mac:
	@echo "Installing dependencies for macOS..."
	brew install massdns jq nmap
	@echo "Installing Go tools..."
	@which go > /dev/null || (echo "Go is not installed. Please install Go 1.19+ first." && exit 1)
	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
	go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
	go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
	go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
	brew install findomain
	@echo "✓ All dependencies installed"
	@echo "Add Go bin to PATH if needed: export PATH=\$$PATH:\$$(go env GOPATH)/bin"

install-linux:
	@echo "Installing dependencies for Linux..."
	sudo apt-get update
	sudo apt-get install -y massdns jq nmap build-essential git
	@which go > /dev/null || (echo "Go is not installed. Please install Go 1.19+ first." && exit 1)
	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
	go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
	go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
	go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
	wget https://github.com/findomain/findomain/releases/download/9.0.0/findomain-linux-x86_64.zip && \
	unzip findomain-linux-x86_64.zip && \
	sudo mv findomain /usr/local/bin/ && \
	sudo chmod +x /usr/local/bin/findomain && \
	rm findomain-linux-x86_64.zip
	@echo "✓ All dependencies installed"
	@echo "Add Go bin to PATH if needed: export PATH=\$$PATH:\$$(go env GOPATH)/bin"

test:
	@echo "Running basic tests..."
	@bash -n script && echo "✓ Script syntax is valid"
	@./script -h > /dev/null && echo "✓ Help command works"
	@echo "Testing dependency check..."
	@./script -d test.local 2>&1 | grep -q "Checking dependencies" && echo "✓ Dependency check works"

docker:
	@echo "Building Docker image $(DOCKER_IMAGE)..."
	docker build -t $(DOCKER_IMAGE) .
	@echo "✓ Docker image built successfully"
	@echo "Run with: docker run -v \$$(pwd)/results:/results $(DOCKER_IMAGE) -d example.com"

docker-run:
	@echo "Running DNS recon on example.com..."
	docker run -v $$(pwd)/results:/results $(DOCKER_IMAGE) -d example.com -q
	@echo "Results saved to ./results/"

docker-shell:
	@echo "Starting interactive Docker shell..."
	docker run -it -v $$(pwd)/results:/results $(DOCKER_IMAGE) bash

lint:
	@echo "Linting script..."
	@command -v shellcheck > /dev/null || (echo "shellcheck not found. Install with: brew install shellcheck" && exit 1)
	shellcheck script

format:
	@echo "Formatting script..."
	@command -v shfmt > /dev/null || (echo "shfmt not found. Install with: go install mvdan.cc/sh/v3/cmd/shfmt@latest" && exit 1)
	shfmt -i 4 -w script

setup-resolvers:
	@echo "Downloading public DNS resolvers..."
	mkdir -p data
	curl -s https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt -o data/resolvers.txt
	@echo "✓ Resolvers saved to data/resolvers.txt"

quick-test:
	@echo "Running quick test on test.local (will fail - for structure validation only)..."
	@./script -d test.local -q 2>/dev/null || echo "✓ Test execution flow validated"

check-os:
	@if [[ "$(shell uname -s)" == "Darwin" ]]; then \
		echo "macOS detected"; \
	elif [[ "$(shell uname -s)" == "Linux" ]]; then \
		echo "Linux detected"; \
	else \
		echo "Unsupported OS"; exit 1; \
	fi

clean:
	@echo "Cleaning up..."
	rm -rf dns_recon_results_*
	rm -rf results/
	rm -f *.log
	@echo "✓ Clean complete"

.DEFAULT_GOAL := help

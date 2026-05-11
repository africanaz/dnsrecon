# DNS Reconnaissance Tool - Modern Edition v2.0

A comprehensive, actively-maintained DNS enumeration toolkit using modern, well-supported security tools. This is a complete rewrite of the original dnsrecon script with updated tools, better architecture, and enhanced reporting.

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-actively%20maintained-brightgreen)

## 🚀 What's New in v2.0

### Tool Stack Modernization
- ✅ **Subfinder** - Multi-source subdomain enumeration (actively maintained)
- ✅ **Findomain** - Fast alternative with complementary sources
- ✅ **dnsx** - Modern DNS validation with record type support
- ✅ **massdns** - Batch DNS resolution for efficiency
- ✅ **nuclei** - Vulnerability detection on discovered targets
- ✅ **httpx** - HTTP probing and title grabbing
- ✅ **jq** - JSON processing for structured output

### Key Improvements
- **Better maintenance**: All tools are actively developed
- **Structured output**: Organized results in raw/processed directories
- **HTML reporting**: Beautiful visual reports
- **Flexible modes**: Quick scan or comprehensive enumeration
- **Better error handling**: Graceful degradation when tools fail
- **Modern aesthetics**: Colored output with progress indicators
- **Dependency checking**: Clear guidance on missing tools

## 📋 Requirements

### Core Dependencies (Required)
- `subfinder` - [projectdiscovery/subfinder](https://github.com/projectdiscovery/subfinder)
- `findomain` - [findomain/findomain](https://github.com/findomain/findomain)
- `dnsx` - [projectdiscovery/dnsx](https://github.com/projectdiscovery/dnsx)
- `massdns` - [blechschmidt/massdns](https://github.com/blechschmidt/massdns)
- `nuclei` - [projectdiscovery/nuclei](https://github.com/projectdiscovery/nuclei)
- `httpx` - [projectdiscovery/httpx](https://github.com/projectdiscovery/httpx)
- `jq` - JSON query tool

### Optional Tools
- `nmap` - For port scanning (use with `-p` flag)
- `curl` - For downloading resolver lists

## 🔧 Installation

### macOS (Homebrew)
```bash
# Core tools
brew install massdns jq

# Go-based tools (requires Go 1.19+)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Findomain
brew install findomain
```

### Linux (Ubuntu/Debian)
```bash
# System packages
sudo apt-get update
sudo apt-get install -y massdns jq git build-essential

# Go-based tools (requires Go 1.19+)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Findomain
wget https://github.com/findomain/findomain/releases/download/9.0.0/findomain-linux-x86_64.zip
unzip findomain-linux-x86_64.zip
sudo mv findomain /usr/local/bin/
sudo chmod +x /usr/local/bin/findomain
```

### Linux (Fedora/RHEL)
```bash
# System packages
sudo dnf install -y massdns jq

# Go-based tools (same as above)
```

### Docker (Recommended)
```bash
# Build the image
docker build -t dnsrecon:2.0 .

# Run
docker run -v $(pwd)/results:/results dnsrecon:2.0 -d example.com
```

## 📖 Usage

### Basic Scan
```bash
./script -d example.com
```

### Quick Mode (Faster, less comprehensive)
```bash
./script -d example.com -q
```

### Full Scan with Vulnerability Detection
```bash
./script -d example.com -v
```

### Scan with Port Discovery
```bash
./script -d example.com -p
```

### Custom Output Directory
```bash
./script -d example.com -o my_results
```

### All Options
```bash
./script -d example.com \
  -o results_2026 \
  -t 50 \
  -r /path/to/resolvers.txt \
  -v \
  -p
```

### Options Reference
| Flag | Description | Default |
|------|-------------|---------|
| `-d DOMAIN` | Target domain **(required)** | - |
| `-o DIR` | Output directory | `dns_recon_results_*` |
| `-q` | Quick mode (subfinder + dnsx only) | Full scan |
| `-v` | Enable vulnerability scanning | Disabled |
| `-p` | Enable port scanning | Disabled |
| `-t THREADS` | Thread count | 20 |
| `-r FILE` | Custom resolvers file | Auto-download |
| `-h` | Show help | - |

## 📊 Output Structure

```
dns_recon_results_20260511_120000/
├── raw/
│   ├── subfinder_20260511_120000.txt
│   ├── findomain_20260511_120000.txt
│   ├── dnsx_resolved_20260511_120000.txt
│   ├── dnsx_resolved_20260511_120000.json
│   └── massdns_20260511_120000.txt
├── processed/
│   ├── all_subdomains_20260511_120000.txt
│   ├── unique_ips_20260511_120000.txt
│   ├── resolved_hosts_20260511_120000.txt
│   └── nuclei_results_20260511_120000.json
├── DNS_Recon_Report_20260511_120000.html
├── dns_recon_20260511_120000.log
└── resolvers.txt
```

## 🎯 Examples

### Reconnaissance of a Bug Bounty Target
```bash
./script -d target.com -v -o bounty_target -t 50
# Results in: bounty_target/ with full enumeration and vuln scan
```

### Quick Assessment
```bash
./script -d startup.io -q
# Fast scan with just subfinder and DNS validation
# Takes ~30 seconds
```

### Comprehensive Assessment with Port Mapping
```bash
./script -d enterprise.com -p -v -o comprehensive_scan
# Finds subdomains → resolves → scans ports → checks vulns
# Takes 10-20 minutes depending on scope
```

### Batch Processing
```bash
for domain in $(cat domains.txt); do
  ./script -d "$domain" -q -o "results/$domain"
done
```

## 🔍 Understanding the Tools

| Tool | Purpose | Why It's Modern |
|------|---------|-----------------|
| **subfinder** | Multi-source subdomain discovery | ProjectDiscovery standard, 30+ sources, fast |
| **findomain** | Alternative enumeration | Rust-based, independent sources, low FP |
| **dnsx** | DNS validation & resolution | Handles CNAME/NS/SOA, concurrent, efficient |
| **massdns** | Batch DNS resolution | Industry standard, 1000s per second, accurate |
| **nuclei** | Vulnerability detection | Signature-based, ML-enhanced, community templates |
| **httpx** | HTTP probing | Title/status/tech detection, built for workflows |

## ⚠️ Ethical and Legal

**IMPORTANT**: Use this tool only on systems you own or have explicit written permission to test.

- DNS enumeration can reveal infrastructure details
- Use responsibly in authorized security assessments
- Respect rate limits and target system resources
- Comply with local laws and regulations

## 🐛 Troubleshooting

### "command not found: subfinder"
```bash
# Ensure Go bins are in PATH
export PATH=$PATH:$(go env GOPATH)/bin
```

### "massdns: command not found"
```bash
# Ubuntu/Debian
sudo apt-get install massdns

# macOS
brew install massdns
```

### DNS Resolution Timeout
```bash
# Use custom resolvers
./script -d example.com -r ~/resolvers.txt
```

### Port Scanning is Slow
```bash
# Skip port scanning or reduce ports
./script -d example.com -q
```

## 📈 Performance Tips

1. **Quick Mode for Large Scopes**: Use `-q` for domains with 1000+ subdomains
2. **Increase Threads**: `-t 100` for faster enumeration (be respectful)
3. **Multiple Runs**: Different tools find different subdomains; run multiple times
4. **Filter Results**: Process output with `sort -u`, grep, or jq

## 🔄 Migration from v1.0

v2.0 is a complete rewrite. If you have old results:

```bash
# Old tools (deprecated):
# - nmap (still optional)
# - fierce (replaced by dnsx)
# - dnsrecon (redundant with subfinder/dnsx)
# - dnsmap (redundant with subfinder)
# - amass (overlaps with subfinder)
# - sublist3r (overlaps with subfinder)
# - massdns (kept - still excellent)

# Migration: Just use new script on your targets
./script -d your_domain.com
```

## 📝 Output Formats

### Subdomains (TXT)
```
api.example.com
app.example.com
cdn.example.com
```

### Resolved IPs (TXT)
```
192.0.2.1
192.0.2.5
203.0.113.42
```

### Nuclei Results (JSON)
```json
{
  "template-id": "cve-2021-24919",
  "type": "vulnerability",
  "severity": "high",
  "host": "api.example.com"
}
```

## 🤝 Contributing

Found improvements? Have suggestions?

1. Test on your own infrastructure
2. Document the change
3. Submit a PR with examples

## 📜 License

MIT License - See LICENSE file for details

## 🔗 Related Projects

- [Subfinder Documentation](https://docs.projectdiscovery.io/tools/subfinder)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [ProjectDiscovery Tools](https://projectdiscovery.io/)

## 📞 Support

- Issues/Questions: Open a GitHub issue
- Feedback: Discussions in the repository

---

**Last Updated**: May 2026  
**Maintainer**: africanaz  
**Status**: Actively Maintained ✅

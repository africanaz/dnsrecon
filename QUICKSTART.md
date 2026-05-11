# 🚀 Quick Start Guide - DNSRecon v2.0

Get started in 5 minutes!

## Installation (Choose One)

### macOS with Homebrew
```bash
# Install dependencies
brew install massdns jq nmap findomain

# Install Go tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Add Go bin to PATH
export PATH=$PATH:$(go env GOPATH)/bin
```

### Linux (Ubuntu/Debian)
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y massdns jq nmap curl

# Install Go tools
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

# Install findomain
wget https://github.com/findomain/findomain/releases/download/9.0.0/findomain-linux-x86_64.zip
unzip findomain-linux-x86_64.zip && sudo mv findomain /usr/local/bin/

# Add Go bin to PATH
export PATH=$PATH:$(go env GOPATH)/bin
```

### Docker (Fastest)
```bash
# Just need Docker installed
docker build -t dnsrecon:2.0 .
```

## Your First Scan

### 1. Fastest Way (30 seconds)
```bash
./script -d example.com -q
# Results in: dns_recon_results_*/ directory
```

### 2. Standard Scan (2 minutes)
```bash
./script -d example.com
# More comprehensive, same output
```

### 3. Full Assessment (10 minutes)
```bash
./script -d example.com -v
# Includes vulnerability scanning
```

### 4. With Docker
```bash
docker run -v $(pwd)/results:/results dnsrecon:2.0 -d example.com
```

## View Results

```bash
# List findings
cat dns_recon_results_*/processed/all_subdomains_*.txt

# View discovered IPs
cat dns_recon_results_*/processed/unique_ips_*.txt

# Open HTML report
open dns_recon_results_*/DNS_Recon_Report_*.html
# or
firefox dns_recon_results_*/DNS_Recon_Report_*.html
```

## Common Commands

| Task | Command |
|------|---------|
| Quick test | `./script -d example.com -q` |
| Full scan | `./script -d example.com` |
| With vulns | `./script -d example.com -v` |
| With ports | `./script -d example.com -p` |
| Custom output | `./script -d example.com -o my_results` |
| More threads | `./script -d example.com -t 100` |
| Help | `./script -h` |

## Understanding Output

```
dns_recon_results_20260511_120000/
├── raw/                           # Raw tool output
│   ├── subfinder_*.txt
│   ├── findomain_*.txt
│   └── dnsx_resolved_*.json
├── processed/                     # Clean, deduplicated
│   ├── all_subdomains_*.txt       ← Main findings!
│   ├── unique_ips_*.txt
│   └── nuclei_results_*.json      # If running with -v
├── DNS_Recon_Report_*.html        # Visual report
└── dns_recon_*.log                # Execution log
```

## Interpreting Results

### all_subdomains_*.txt
```
api.example.com
app.example.com
cdn.example.com
mail.example.com
api-dev.example.com
```
→ These are subdomains to test further

### unique_ips_*.txt
```
192.0.2.1
192.0.2.5
203.0.113.42
```
→ Servers hosting the domain

### DNA_Recon_Report_*.html
→ Visual overview, open in browser

## Troubleshooting

### "command not found"
```bash
# Go tools not in PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Make permanent:
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
```

### "massdns: command not found"
```bash
# Install it:
brew install massdns      # macOS
# OR
sudo apt-get install massdns  # Linux
```

### Script won't run
```bash
chmod +x script
```

### No results found
```bash
# Check the log file
cat dns_recon_*.log

# Verify internet connection
ping google.com

# Test with a known domain
./script -d google.com -q
```

## Tips & Tricks

### Batch Processing Multiple Domains
```bash
for domain in example.com test.io startup.io; do
  ./script -d "$domain" -q -o "results/$domain"
done
```

### Extract Just IPs
```bash
cat dns_recon_results_*/processed/unique_ips_*.txt | sort -u
```

### Search for Specific Subdomain
```bash
grep "api" dns_recon_results_*/processed/all_subdomains_*.txt
```

### Run with More Threads (Faster)
```bash
./script -d example.com -t 100  # Default is 20
```

### Use Custom Resolvers
```bash
./script -d example.com -r ~/my_resolvers.txt
```

## Next Level

### Vulnerability Scanning
```bash
./script -d example.com -v
# Generates: nuclei_results_*.json
```

### Port Discovery
```bash
./script -d example.com -p
# Requires nmap, takes longer
```

### Combination
```bash
./script -d example.com -v -p -t 50
# Full assessment with 50 threads
```

## Real-World Example

```bash
# Day 1: Quick reconnaissance
./script -d startup.io -q

# Day 2: Deep dive based on findings
./script -d startup.io -o deep_dive -v -t 100

# Day 3: Check for vulnerabilities on discovered services
./script -d startup.io -p -v

# Results:
# - all_subdomains: 147 targets to test
# - unique_ips: 12 servers
# - nuclei_results: 3 vulnerabilities found
```

## Legal Reminder ⚠️

**ONLY USE ON SYSTEMS YOU OWN OR HAVE WRITTEN PERMISSION TO TEST**

- DNS enumeration reveals infrastructure
- Unauthorized testing is illegal
- Always get written approval
- Respect rate limits

## More Help

```bash
# Full help
./script -h

# See all examples
cat README_modern.md

# Check installation
./script -d example.local -q 2>&1 | head -20
```

## Success Checklist ✅

- [ ] All tools installed (`./script -h` works)
- [ ] Can run quick test (`./script -d example.com -q`)
- [ ] Found output directory
- [ ] Can open HTML report
- [ ] Ready for real scan!

---

**That's it! You're ready to enumerate some domains.** 🎉

For detailed documentation, see `README_modern.md`
For migration help, see `UPGRADE_GUIDE.md`

# Cash_Cache :rocket:

Cash_Cache is a powerful automation script designed for penetration testers, hackers, and bug bounty hunters. It streamlines the process of domain enumeration and vulnerability assessment, enabling users to gather critical information and automate various security tasks. With an array of tools and techniques, Cash_Cache provides comprehensive automation for reconnaissance and assessment.

***Disclaimer: This script is intended for educational purposes only. Unauthorized use of Cash_Cache on systems or networks without proper permission is strictly prohibited. The developers and contributors of Cash_Cache are not responsible for any misuse or illegal activities conducted with this script. Use it responsibly and ethically.***


## Features :hammer_and_wrench:

- Subdomain Enumeration: Utilizes tools like `subfinder` to discover subdomains associated with the target domain.
- Visual Check: Captures screenshots of discovered subdomains using `aquatone` for visual inspection and analysis.
- Subdomain Takeover Check: Identifies potential subdomains susceptible to takeover using `subjack`.
- Directory Fuzzing: Conducts directory fuzzing on discovered subdomains using `ffuf` to identify hidden directories and files.
- Request Smuggling Detection: Detects HTTP request smuggling vulnerabilities using `smuggler.py`.
- Nuclei Scan: Performs a vulnerability scan on discovered subdomains using `nuclei` and a collection of templates.
- Live Subdomains: Identifies live subdomains using `naabu` and `httpx` by conducting port scanning and verifying HTTP services.
- Live URLs: Retrieves live URLs from the Wayback Machine using `waybackurls` for further analysis and testing.
- Path Extraction: Extracts paths from live URLs using `unfurl` to identify potential entry points for security analysis.
- LinkFinder: Identifies JavaScript endpoints within live URLs using `LinkFinder` for further security analysis.
- CORS Misconfiguration Scan: Detects CORS misconfigurations using `CORScanner` to highlight potential vulnerabilities.
- Zone Transfer Check: Checks for zone transfer vulnerability using `dnsrecon` to assess DNS configuration.

## Prerequisites :wrench:

Before using Cash_Cache, ensure that you have the following tools installed and accessible via the system's PATH:

- [subfinder](https://github.com/projectdiscovery/subfinder)
- [aquatone](https://github.com/michenriksen/aquatone)
- [subjack](https://github.com/haccer/subjack)
- [ffuf](https://github.com/ffuf/ffuf)
- [smuggler.py](https://github.com/defparam/smuggler.py)
- [nuclei](https://github.com/projectdiscovery/nuclei)
- [naabu](https://github.com/projectdiscovery/naabu)
- [httpx](https://github.com/projectdiscovery/httpx)
- [waybackurls](https://github.com/tomnomnom/waybackurls)
- [unfurl](https://github.com/tomnomnom/unfurl)
- [LinkFinder](https://github.com/GerbenJavado/LinkFinder)
- [CORScanner](https://github.com/chenjj/CORScanner)
- [dnsrecon](https://github.com/darkoperator/dnsrecon)

Please refer to the respective tool documentation for installation instructions.

## Usage :mag_right:

1. Clone the Cash_Cache repository to your local machine:

   ```bash
   git clone https://github.com/cy-cus/cash_cache.git

2. Navigate to the project directory:

   ```cd cash_cache```

3. Make the cash_cache.sh script executable:

   ```chmod +x cash_cache.sh```


4. Run the script with the target domain as an argument:

   ```./cash_cache.sh domains.txt```

Replace domains.txt with the target domain list you want to assess.

## Workflow :clipboard:
The Cash_Cache script performs the following steps:

### Subdomain Enumeration:

Uses subfinder to discover subdomains associated with the target domain.

### Taking Screenshots:

Captures screenshots of discovered subdomains using aquatone for visual inspection and analysis.

### Subdomain Takeover Check:

Identifies potential subdomains susceptible to takeover using subjack.

### Directory Fuzzing:

Conducts directory fuzzing on discovered subdomains using ffuf to identify hidden directories and files.

### Request Smuggling Detection:

Detects HTTP request smuggling vulnerabilities using smuggler.py.

### Port Scanning:

Uses naabu to scan all the found subdomains for open ports, it then pipes the results to httpx and probes for which of the subdomains are live and accessible

### Scanning For Known Vulnerabilities:

Performs a vulnerability scan on discovered subdomains after running a port scan on all of the subdomains. It uses nuclei and a collection of templates to discover known vulnerabilities on the ports open.

### Finding All URLs:

Retrieves URLs from the Wayback Machine using waybackurls for further analysis and testing.

### Path Extraction:

Extracts paths from the URLs found  from the wayback machine using unfurl to identify potential entry points for security analysis.

### Finding Javascript Endpoints:

Identifies JavaScript endpoints within the URLs using LinkFinder for further security analysis.

### CORS Misconfiguration Scan:

Detects CORS misconfigurations using CORScanner to highlight potential vulnerabilities.

### Zone Transfer Check:

Checks for zone transfer vulnerability using dnsrecon to assess DNS configuration.


The script automates the execution of these steps to provide a comprehensive domain enumeration and vulnerability assessment. It combines the results from various tools and saves them for further analysis and remediation.
Using Cash_Cache has significantly contributed to my success in finding vulnerabilities and securing bug bounties
Also you can create a program specific wodlist from the paths found and the javascript endpoints

Happy hunting! :male_detective:

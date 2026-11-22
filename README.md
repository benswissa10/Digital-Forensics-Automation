# Cybersecurity Lab Portfolio | Ben Swissa

Hands-on security automation projects developed during cybersecurity training, with public-facing refactors documented for technical review.

## 1. Digital Forensics Automation (NX212)
**Tools:** Bash, Linux, Foremost, Bulk Extractor, optional Volatility 2

A forensic triage workflow for authorized evidence files, including SHA-256 evidence hashing, file carving, keyword triage, logging and analysis summaries.

- [Source code](forensic_triage.sh)
- [Usage and limitations](#digital-forensics-usage)

### Digital Forensics usage
```bash
chmod +x forensic_triage.sh
./forensic_triage.sh /path/to/authorized-evidence.raw ./analysis-output
```

## 2. Network Security & Reconnaissance (NX220)
**Tools:** Bash, Nmap, Python 3

A scoped network reconnaissance lab project with CIDR validation, explicit authorization confirmation, basic scanning, service enumeration and structured logs.

- [Network Security project README](network-security/README.md)
- [Network reconnaissance script](network-security/network_recon.sh)

## Project background and status
Both repositories' workflows are based on course projects I developed as part of hands-on cybersecurity training. The original forensic project was run on lab evidence. These **refactored public versions still require end-to-end execution and output validation** before being described as fully tested. No specific detection, exploitation, vulnerability, or recovery result is claimed.

## Safe handling
Do not commit memory dumps, extracted files, credentials, scan inventories, private network details or incident artifacts. Generated outputs should be reviewed and kept private. Use only on systems and evidence you own or have written permission to assess.

## Career focus
Junior SOC Analyst | SIEM | Endpoint Security | Digital Forensics | Incident Investigation

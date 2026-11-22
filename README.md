# Cybersecurity Lab Portfolio | Ben Swissa

A collection of **five cybersecurity lab projects** developed during my cybersecurity training, with public-facing Bash refactors documenting practical skills, safe workflows, and technical limitations.

## Projects

| Project | Primary skills | Files |
| --- | --- | --- |
| **Digital Forensics Automation (NX212)** | Bash, evidence hashing, Foremost, Bulk Extractor, optional Volatility | [Project](digital-forensics/README.md) |
| **Network Security & Reconnaissance (NX220)** | Nmap, network scanning, service enumeration, reporting | [Project](network-security/README.md) |
| **Penetration Testing Assessment (ZX301)** | Controlled service assessment, Bash, Nmap, reporting | [Project](penetration-testing/README.md) |
| **Remote SSH Automation (NX201)** | Authorized remote Linux inventory, SSH, Bash | [Project](remote-ssh-automation/README.md) |
| **SOC Detection Lab (Synthetic)** | Offline Python detection, Splunk SPL examples and an SSH incident case study | [Project](soc-detection-lab/README.md) |

## Digital Forensics (NX212)
The forensic triage workflow hashes authorized evidence, runs optional artifact-extraction tools, collects keyword matches and saves analyst notes locally.

```bash
cd digital-forensics
chmod +x forensic_triage.sh
./forensic_triage.sh /path/to/authorized-evidence.raw ./analysis-output
```

## Project status and limitations
The original NX212 course project was executed on lab evidence. The public scripts are **refactored learning artifacts** and have **not been independently validated end-to-end** against suitable lab targets or evidence. Do not infer verified findings, incident detections, successful exploitation or production SOC experience from their presence.

The original ZX301 project also covered more aggressive credential-testing techniques. These are intentionally **not included in the public refactor**.

## Safe handling
All testing must be explicitly authorized. Do not publish memory dumps, extracted passwords, customer data, internal IP inventories, real scan logs or private investigation artifacts. Generated files belong outside the public repository.

## Career focus
Junior SOC Analyst | Digital Forensics | SIEM | Endpoint Security | Network Analysis

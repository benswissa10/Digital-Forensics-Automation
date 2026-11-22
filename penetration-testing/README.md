# Penetration Testing Lab: Service Assessment (ZX301)

This repository folder documents a controlled, public-facing refactor of my **ZX301 Penetration Testing** course project.

## Original project scope
The original Bash script included Nmap scanning, vulnerability lookups, configurable service tests, and credential checks using Hydra or Medusa. Those functions are part of the course script's design, not evidence of a successful compromise.

## Public version
The published script is intentionally limited to:
- Single-host IPv4 input validation
- Explicit authorization confirmation
- Nmap TCP service enumeration on a small port set
- Local execution logging and an analyst summary

It does **not** perform password attacks, exploitation, or verified vulnerability confirmation. Its name and documentation describe only what it actually does.

## Requirements
Bash, Python 3, Nmap and an isolated or explicitly authorized test host.

## Run
```bash
chmod +x assessment_report.sh
./assessment_report.sh 192.0.2.10 ./assessment-output
```

Review `services.txt`, `summary.txt` and `run.log` locally. **Do not publish internal scan outputs, credentials, or client data.**

## Validation
Refactored from an original student assignment. This public version has **not yet been end-to-end validated in a lab**. Do not claim live findings or successful tests without results.

For educational and authorized security assessments only.

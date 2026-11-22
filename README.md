# Digital Forensics Automation

A Bash-based forensic triage workflow, adapted from my **NX212 Windows Forensics** lab project. I developed and ran the original project as part of hands-on cybersecurity training.

## What it demonstrates

- Linux/Bash workflow automation, input validation and evidence hashing
- File carving with **Foremost** and artifact extraction with **Bulk Extractor**
- Simple keyword triage from readable strings
- Optional **Volatility 2** memory image profiling when `vol.py` is installed
- Clear run logs and a summary for analyst review

**Scope:** an educational forensic triage helper, **not** a complete forensic suite or a production SOC detection system. The tool does not automatically identify malicious activity or guarantee successful extraction.

## Requirements

- Bash, `sha256sum`, `tee`, `awk`, `grep`
- Optional: `foremost`, `bulk_extractor`, `strings`, Volatility 2
- A local evidence file you have permission to analyze

Dependencies are not automatically installed. Install optional forensic tools from trusted sources according to your lab environment.

## Usage

```bash
chmod +x forensic_triage.sh
./forensic_triage.sh /path/to/authorized-evidence.raw ./analysis-output
```

The output directory must not already exist, to avoid overwriting prior evidence. Results include a run log, SHA-256 checksum, tool outputs when available, and an analyst summary.

> **Privacy:** Real memory dumps, keyword matches, carved files, extracted credentials, and other forensic artifacts may expose sensitive information. Keep these files off public repositories. The `.gitignore` excludes common output folders and dump extensions, but it is not a substitute for manual review.

## How the original lab was improved

The original NX212 Bash script attempted to auto-install tools and download a legacy Volatility binary, changed permissions broadly, and extracted credential hashes. The public version removes automatic downloads, broad permissions and hash extraction, adds safer input checks, and keeps evidence outputs local.

## Validation status

- This repository contains a refactored version of a previously executed student lab project.
- **The refactored version has not yet been end-to-end validated against an evidence image.** No sample findings or success rates are claimed.
- Before relying on results, validate with an authorized test image and inspect logs for skipped or failed tools.

## Interview discussion

Possible technical discussion points: forensic integrity and hashing, differences between file carving and memory analysis, why Volatility needs an appropriate memory profile, sensitive data handling, and interpretation limits.

## Disclaimer

For education and authorized investigations only. Never analyze systems, images or data without permission.

# Digital Forensics Automation (NX212)

A Bash-based forensic triage workflow adapted from my hands-on NX212 Windows Forensics training project.

## Skills and tools
- Bash scripting and Linux automation
- Evidence integrity checks using SHA-256
- File carving with **Foremost** and artifact extraction with **Bulk Extractor**
- Content-based keyword triage from readable strings
- Optional Volatility 2 memory profile inspection, when the appropriate `vol.py` tool is installed
- Local logging and analysis summaries

## Requirements
Bash, standard Linux utilities and a readable evidence file you own or are authorized to analyze. Foremost, Bulk Extractor, strings and Volatility are optional tools. Dependencies are **not** installed automatically.

## How to run
Run from this directory:

```bash
chmod +x forensic_triage.sh
./forensic_triage.sh /path/to/authorized-evidence.raw ./analysis-output
```

The output directory must not already exist. Results and logs should remain local.

## What the script actually does
1. Validates the input file and output location.
2. Computes a SHA-256 hash of the evidence file.
3. Invokes optional carving and extraction tools when installed.
4. Searches readable strings for selected keywords (which may reveal sensitive content).
5. Optionally runs Volatility 2 `imageinfo`; manual validation is required before memory-profile-dependent analysis.
6. Produces a local summary and execution log.

## Validation and limitations
The original NX212 lab project was executed on lab evidence. This **public refactor has not been independently validated end-to-end** against an evidence image. No actual recovery result, malware detection, or production incident finding is claimed. It is an educational triage utility, not a complete forensic examination.

## Security and privacy
Never publish memory images, carved files, credentials, recovered content, or keyword hits. Output may contain personally identifying information. Use only authorized evidence.

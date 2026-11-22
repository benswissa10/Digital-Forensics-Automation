#!/usr/bin/env bash
# Network Security & Reconnaissance Automation (NX220-inspired)
# Authorized lab use only. Does not launch exploitation or password attacks.
set -Eeuo pipefail

usage() {
  printf 'Usage: %s <CIDR or IP> <output-directory>\n' "$0"
  printf 'Example: %s 192.0.2.0/28 ./lab-recon-output\n' "$0"
}
if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then usage; exit 0; fi
if (( $# != 2 )); then usage >&2; exit 2; fi
target=$1
out=$2

if ! command -v python3 >/dev/null 2>&1; then
  echo 'Python 3 is required for CIDR validation.' >&2; exit 1
fi
python3 - "$target" <<'PY'
import ipaddress
import sys
try:
    ipaddress.ip_network(sys.argv[1], strict=False)
except ValueError:
    print("Invalid IP/CIDR address", file=sys.stderr)
    sys.exit(1)
PY
if [[ -e "$out" ]]; then
  echo 'Output directory already exists; choose a new folder.' >&2
  exit 1
fi
if ! command -v nmap >/dev/null 2>&1; then
  echo 'nmap is required.' >&2; exit 1
fi
printf 'Confirm you are authorized to scan %s (type YES): ' "$target"
read -r approval
if [[ "$approval" != "YES" ]]; then
  echo 'No authorization confirmation; exiting.'
  exit 1
fi

mkdir -p -- "$out"
exec > >(tee -a "$out/run.log") 2>&1
echo "Started UTC: $(date -u +%FT%TZ)"
echo "Authorized target: $target"
echo '[1/3] Host and port discovery'
if nmap -sT -Pn --top-ports 100 -oN "$out/host_ports.txt" -- "$target"; then
  echo 'Host/port scan completed.'
else
  echo 'Warning: host/port scan failed; review output.'
fi
echo '[2/3] Service enumeration'
if nmap -sT -sV -Pn -p 21,22,53,80,139,389,443,445,3389 -oN "$out/services.txt" -- "$target"; then
  echo 'Service enumeration completed.'
else
  echo 'Warning: service enumeration failed; review output.'
fi
echo '[3/3] Summary'
{
  echo 'Network Security Assessment'
  echo "Target: $target"
  echo "Date UTC: $(date -u +%FT%TZ)"
  echo 'Evidence files: host_ports.txt and services.txt'
  echo 'These are enumeration results, not proof of vulnerabilities.'
  echo 'Manual analyst review and explicit authorization are required.'
} > "$out/summary.txt"
echo 'Done. Keep all assessment results private unless reviewed.'

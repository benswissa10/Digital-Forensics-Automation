#!/usr/bin/env bash
# ZX301-inspired authorized network assessment and local report
# No password guessing or exploitation is performed by this public version.
set -Eeuo pipefail

usage() {
  printf 'Usage: %s <IPv4-address> <output-directory>\n' "$0"
  printf 'Example: %s 192.0.2.10 ./assessment-output\n' "$0"
}
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then usage; exit 0; fi
if (( $# != 2 )); then usage >&2; exit 2; fi
target=$1
out=$2
command -v python3 >/dev/null || { echo 'Python 3 required' >&2; exit 1; }
command -v nmap >/dev/null || { echo 'Nmap required' >&2; exit 1; }

python3 - "$target" <<'PY'
import ipaddress, sys
try:
    ipaddress.IPv4Address(sys.argv[1])
except ValueError:
    print('Expected one valid IPv4 address', file=sys.stderr)
    sys.exit(2)
PY

if [[ -e "$out" ]]; then
  echo 'Output directory already exists; choose a new one' >&2
  exit 1
fi
printf 'Confirm authorization to assess %s (type YES): ' "$target"
read -r approved
if [[ "$approved" != "YES" ]]; then
  echo 'Authorization not confirmed'
  exit 1
fi

mkdir -p -- "$out"
printf 'Started UTC: %s\n' "$(date -u +%FT%TZ)" > "$out/run.log"
echo 'Running TCP service enumeration (not exploitation)' | tee -a "$out/run.log"
if nmap -sT -sV -Pn -p 21,22,23,80,443,445,3389 -oN "$out/services.txt" "$target" >> "$out/run.log" 2>&1; then
  echo 'Enumeration completed' | tee -a "$out/run.log"
else
  echo 'Enumeration failed; see run.log' | tee -a "$out/run.log" >&2
  exit 1
fi

{
  echo 'Authorized Network Assessment: Analyst Notes'
  echo "Target: $target"
  echo "Timestamp UTC: $(date -u +%FT%TZ)"
  echo 'Evidence file: services.txt'
  echo 'Results are service observations, not verified vulnerabilities.'
  echo 'Manually verify scope, findings, risks and remediation before reporting.'
} > "$out/summary.txt"
echo 'Assessment complete; keep raw output private' | tee -a "$out/run.log"

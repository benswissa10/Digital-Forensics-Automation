#!/usr/bin/env bash
# Digital Forensics Automation
# Refactored from Ben Swissa's NX212 cybersecurity lab project.
# Run only on files that you own or are authorized to analyze.
set -Eeuo pipefail

usage() {
  printf 'Usage: %s <evidence-file> [output-directory]\n' "$0"
  printf 'Example: %s ./sample-memory.raw ./analysis-output\n' "$0"
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then usage; exit 0; fi
if (( $# < 1 || $# > 2 )); then usage >&2; exit 2; fi

evidence=$1
output=${2:-analysis-output}
if [[ ! -f "$evidence" || ! -r "$evidence" ]]; then
  printf 'Error: evidence file is not readable: %s\n' "$evidence" >&2
  exit 1
fi
if [[ -e "$output" ]]; then
  printf 'Error: output path already exists (choose a new folder): %s\n' "$output" >&2
  exit 1
fi
mkdir -p -- "$output"
log="$output/run.log"
exec > >(tee -a "$log") 2>&1
printf 'Digital Forensics Automation | %s\n' "$(date -u +%FT%TZ)"
printf 'Input: %s\n' "$evidence"
printf 'SHA-256: '
sha256sum -- "$evidence"

run_optional() {
  local tool=$1; shift
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf '[SKIP] %s not installed\n' "$tool"
    return 0
  fi
  printf '[RUN] %s\n' "$tool"
  if "$@"; then
    printf '[OK] %s completed\n' "$tool"
  else
    printf '[WARN] %s failed; inspect log and tool output\n' "$tool"
  fi
}
run_optional foremost foremost -i "$evidence" -o "$output/foremost"
run_optional bulk_extractor bulk_extractor -o "$output/bulk_extractor" "$evidence"

# Content-based keyword triage: output may contain secrets or personal data.
# Never upload extracted matches or raw evidence to public repositories.
if command -v strings >/dev/null 2>&1; then
  if strings -a -- "$evidence" | grep -Ei 'password|username|\.exe' > "$output/keyword_hits.txt"; then
    printf '[OK] Extracted keyword matches into private output\n'
  else
    printf '[INFO] No keyword matches (or strings failed)\n'
  fi
fi

# Volatility 2 is optional and must be installed separately. The evidence
# profile needs validation by the analyst; do not guess it silently.
if command -v vol.py >/dev/null 2>&1; then
  printf '[INFO] Volatility 2 detected. Run imageinfo and validate the profile manually.\n'
  vol.py -f "$evidence" imageinfo > "$output/volatility_imageinfo.txt" 2>&1 || true
elif command -v volatility >/dev/null 2>&1; then
  printf '[INFO] Volatility CLI detected. See README for version-specific usage.\n'
else
  printf '[SKIP] Volatility not installed\n'
fi

{
  printf 'Analysis summary\n'
  printf 'Timestamp (UTC): %s\n' "$(date -u +%FT%TZ)"
  printf 'Evidence SHA-256: %s\n' "$(sha256sum -- "$evidence" | awk '{print $1}')"
  printf 'Tool availability:\n'
  for tool in foremost bulk_extractor strings vol.py volatility; do
    if command -v "$tool" >/dev/null 2>&1; then printf '  %s: installed\n' "$tool"
    else printf '  %s: not installed\n' "$tool"; fi
  done
  printf '\nAll generated artifacts may contain sensitive evidence. Do not commit them.\n'
} > "$output/summary.txt"
printf '[DONE] Private results saved in: %s\n' "$output"

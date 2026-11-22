#!/usr/bin/env bash
# NX201-inspired authorized SSH host inventory
set -Eeuo pipefail

usage() {
  printf 'Usage: %s <user@host> <output-directory>\n' "$0"
  printf 'Example: %s analyst@192.0.2.10 ./ssh-lab-output\n' "$0"
}
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then usage; exit 0; fi
if (( $# != 2 )); then usage >&2; exit 2; fi

target=$1
out=$2
if [[ ! "$target" =~ ^[a-zA-Z_][a-zA-Z0-9_.-]*@[a-zA-Z0-9_.-]+$ ]]; then
  echo 'Invalid user@host format' >&2
  exit 2
fi
if [[ -e "$out" ]]; then
  echo 'Output directory already exists; choose a new one' >&2
  exit 1
fi
command -v ssh >/dev/null || { echo 'OpenSSH client required' >&2; exit 1; }

printf 'Confirm authorization to access %s (type YES): ' "$target"
read -r approved
if [[ "$approved" != "YES" ]]; then
  echo 'Authorization not confirmed'
  exit 1
fi

mkdir -p -- "$out"
echo "Started UTC: $(date -u +%FT%TZ)" > "$out/run.log"
# Uses existing SSH keys/agent. Never disables host-key verification.
if ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=10 \
  "$target" 'hostname; uptime; uname -srm' > "$out/host_metadata.txt" 2>> "$out/run.log"; then
  echo 'Metadata collected; review locally before sharing' | tee -a "$out/run.log"
else
  echo 'SSH connection failed; check approved host key, access, and run.log' | tee -a "$out/run.log" >&2
  exit 1
fi

# Authorized Remote SSH Inventory (NX201)

This project is a public, safety-focused refactor of my **NX201 Network Research** course project.

## Background
The original Bash lab combined remote SSH administration, host information, WHOIS/Nmap queries and connectivity-related checks. This version deliberately narrows the scope to **authorized SSH host metadata collection**.

## Skills
- Bash scripting and logging
- SSH authentication and host-key verification
- Remote Linux host inventory (hostname, uptime and kernel details)
- Input validation and permission-aware automation

## Requirements
Bash and an OpenSSH client. You need access to an authorized host configured with **SSH keys or an SSH agent**. The remote host must have a trusted entry in `known_hosts`.

## Run
```bash
chmod +x remote_inventory.sh
./remote_inventory.sh analyst@192.0.2.10 ./ssh-lab-output
```

The script asks for authorization confirmation and writes private output to a new directory. No password is requested or embedded in command arguments.

## Security improvements
Unlike the original NX201 lab, this public refactor does not disable SSH host-key checks, store plaintext passwords, install anonymity tools or claim that a foreign IP address provides anonymity. Outputs can contain internal host details and should not be committed.

## Validation
Based on an original student lab script. This public refactor has **not yet been end-to-end tested against an authorized SSH host**. No successful collection is claimed.

For educational and authorized use only.

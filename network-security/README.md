# Network Security & Reconnaissance Automation

An **NX220-inspired** Bash lab project for authorized network reconnaissance. The original student project contained selectable scanning, directory/service enumeration, security testing and reporting modules. This public refactor focuses on a smaller, auditable workflow: input validation, explicit authorization confirmation, Nmap scanning, service enumeration and structured local output.

## Skills demonstrated
- Bash scripting, input validation and tool orchestration
- Network scanning and service identification using **Nmap**
- Evidence logging, reporting and responsible scope management
- Explaining the difference between reconnaissance and confirmed findings

## Requirements
- Linux with Bash, Nmap and Python 3
- An isolated lab network **you own or are explicitly authorized to test**

## Usage
\`\`\`bash
chmod +x network_recon.sh
./network_recon.sh 192.0.2.0/28 ./lab-recon-output
\`\`\`

Type \`YES\` only if you are authorized to scan the specified target. The output directory must not exist already.

## Outputs
- \`host_ports.txt\`: initial TCP scan of common ports
- \`services.txt\`: targeted service enumeration
- \`run.log\`: execution log
- \`summary.txt\`: basic review notes

**Do not upload real internal IP inventories, enumeration outputs, credentials or scan logs to a public repository.**

## Original-versus-public implementation
The original NX220 course script included optional LDAP/SMB enumeration, credential testing and simulated attack menu actions. Some actions logged simulated events rather than executing traffic. The published public version **does not claim to exploit systems, perform credential attacks, compromise Active Directory, or detect confirmed vulnerabilities**.

## Validation
This is a refactor of a hands-on student project. Execution on an authorized live lab target and verification of its output are still pending. No successful scan outcomes are claimed.

## Scope and safety
For education and authorized assessments only. Network reconnaissance can cause operational impact. Obtain explicit permission and use conservative test scopes.

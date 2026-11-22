# Technical Interview Preparation | Ben Swissa

Use this as a study checklist before a Junior SOC Analyst interview. Be clear about what was done in the original course projects versus what was refactored for public GitHub.

## Digital Forensics (NX212)
1. What is file carving, and how does Foremost differ from Bulk Extractor?
2. What does a SHA-256 hash tell you about evidence integrity, and what does it not prove?
3. Why must a Volatility memory profile be validated before plugin execution?
4. How would you investigate suspicious process, network or registry artifacts in a memory image?
5. What sensitive evidence must never be published (credentials, memory dumps, recovered files)?
6. What are the limits of automated keyword searches, and why can false positives occur?

## Network Security & Reconnaissance (NX220)
1. Explain CIDR notation and the difference between a host and a subnet.
2. What is the difference between port discovery, service detection and vulnerability confirmation?
3. What is Nmap -sT, and when would you avoid active scanning?
4. How can enumeration help analysts scope an investigation without proving compromise?
5. Why is a network authorization boundary required before running security tools?
6. Which features were in the original NX220 course script but intentionally excluded from the public refactor?

## SOC Core Fundamentals
- Explain SIEM ingestion, correlation and investigation in Splunk or ELK.
- Explain EDR alert triage, suspicious process ancestry and when isolation is appropriate.
- Know Windows event IDs 4625 (failed logon) and 1102 (audit log cleared), including their limitations.
- Walk through the triage sequence: validate alert, establish timeline, gather evidence, assess scope, contain as authorized, document and escalate.
- Explain true positive, false positive, IOC and MITRE ATT&CK mapping.
- Practice presenting a project clearly in two minutes, including one limitation and one next improvement.

## Evidence and claims
Never say you deployed production SOC tooling or identified a real incident unless it is true. The public refactors have not been validated end to end. The original NX212 lab was executed on lab evidence.

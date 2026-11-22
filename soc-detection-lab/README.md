# SOC Detection Lab | Offline Event Analysis

A **defensive SOC project** that analyzes synthetic JSONL logs for three signals: repeated SSH authentication failures, elevated SYN traffic, and changing ARP IP-to-MAC mappings.

**No attacks, scans, or live-network actions are performed.**

## Features

- Parse timestamped events from JSON Lines files
- Apply configurable event thresholds in sliding time windows
- Generate structured JSON alerts
- Run automated unit tests
- Distinguish alerts from confirmed attacks: SYN bursts are not proof of DDoS, and MAC mapping changes are not proof of ARP spoofing


## Splunk SPL and incident investigation (reproducible lab material)

The repository also includes **four example Splunk SPL searches** and a documented SSH investigation workflow:

- [Splunk lab setup and validation guide](SPLUNK_LAB_GUIDE.md)
- [SSH failure threshold rule](splunk/ssh_bruteforce.spl)
- [Elevated SYN event volume rule](splunk/syn_spike.spl)
- [ARP IP-to-MAC change rule](splunk/arp_mapping_change.spl)
- [SSH investigation timeline query](splunk/ssh_investigation.spl)
- [Sample incident investigation report](incident-report.md)

**Verification boundary:** the Python detector passed its local unit tests on synthetic data. The SPL examples have **not** been run in a connected Splunk instance, and the incident report is a documented **simulation**, not a real incident. Splunk fixed-minute buckets are not identical to the Python rolling 60-second windows.

## Run (Python 3.9+, standard library only)

```bash
cd soc-detection-lab
python3 detect.py samples/synthetic_events.jsonl
python3 detect.py samples/synthetic_events.jsonl --output report.json
python3 -m unittest discover -s tests -v
```

Sample output: **20 synthetic events and 3 alerts**, one per scenario. Adjust thresholds with `--ssh-threshold`, `--syn-threshold`, and `--window-seconds`.

## Event format

```json
{"timestamp":"2026-01-01T00:00:00Z","type":"ssh_failure","src_ip":"192.0.2.10","dst_ip":"192.0.2.20"}
{"timestamp":"2026-01-01T00:00:00Z","type":"tcp_syn","src_ip":"198.51.100.10","dst_ip":"192.0.2.20"}
{"timestamp":"2026-01-01T00:00:00Z","type":"arp_observation","ip":"192.0.2.1","mac":"00:11:22:33:44:55"}
```

## Test results and limitations

The detection design was locally exercised with synthetic events, producing three alerts, and a four-test unit suite passed. The repository version is documented for reproducibility; **no real attack, SIEM, EDR or production investigation has been validated**. Alerts are triage leads, not conclusions.

## Attribution

Three defensive scenarios were suggested by a separate classmate exercise named `soc.sh`. This is a new independently written detection implementation with synthetic sample data. It is **not** the classmate's code and should not be presented as an independently authored personal project without reviewing and understanding it.

# Splunk Lab Guide | SOC Detection Lab

This folder contains **SPL detection and investigation searches**, not a deployed Splunk application. The goal is to reproduce the defensive workflow on the provided **synthetic** JSONL sample. Splunk connectivity and saved alert configuration are **not yet verified**.

## Dataset
`../samples/synthetic_events.jsonl` contains 20 synthetic events with fields `timestamp`, `type`, `src_ip`, `dst_ip`, `ip` and `mac`. Addresses such as `192.0.2.10` and `198.51.100.10` are reserved documentation IPs.

## Manual setup in an authorized Splunk lab
1. Create a **dedicated lab index** such as `soc_lab` if your Splunk deployment allows it.
2. In Splunk Web, use **Add Data > Upload**, select `samples/synthetic_events.jsonl`, choose a JSON sourcetype (example `soc_lab_json`), and select the lab index.
3. Inspect extracted fields and timestamps. The JSON field `timestamp` is ISO-8601 UTC; configure time recognition accordingly. Verify `_time` and the fields before using the searches.
4. Run each search under `splunk/`, replacing the index and sourcetype with the actual values from your lab.
5. Review the results. If supported in your edition/permissions, schedule a search or configure an alert on matching rows. Use a deduplication/suppression policy to avoid noisy alerts.

## Searches
- `splunk/ssh_bruteforce.spl`: counts SSH failures by source/target in **fixed 1-minute buckets**.
- `splunk/syn_spike.spl`: counts SYN events in fixed 1-minute buckets; these events alone do not prove DDoS.
- `splunk/arp_mapping_change.spl`: lists multiple MACs observed for a single IP; benign changes are possible.
- `splunk/ssh_investigation.spl`: timeline investigation starter query. The example dataset contains `ssh_failure` only, **not `ssh_success`**; success correlation would require additional authentic or synthetic events.

## Limitations
The Python detection engine uses **rolling 60-second windows**, while the SPL detection examples use **fixed 1-minute buckets**. They may disagree around minute boundaries. These queries have been reviewed for intended logic but **not run against a Splunk installation** here.

The original classmate-provided Bash script is not included, and this project does **not execute attacks** or connect to a live network. Publish screenshots only after running in your own Splunk instance and redacting sensitive details.

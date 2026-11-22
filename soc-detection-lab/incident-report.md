# Incident Investigation Report | SOC-LAB-001

**Case:** Repeated SSH Authentication Failures (synthetic scenario)  
**Classification:** Suspicious authentication activity / unconfirmed brute-force attempt  
**Source:** `192.0.2.10` (documentation IP)  
**Target:** `192.0.2.20` (documentation IP)  
**Data source:** `samples/synthetic_events.jsonl` (not real system logs)  
**Analyst outcome:** Escalate for contextual validation; do **not** claim compromise.

## 1. Alert
The offline Python detector observed **5 SSH authentication failure events within 20 seconds**, meeting the lab threshold of 5 events within 60 seconds. The sample dataset includes a sixth failure, which the detector's one-alert-per-source/target policy does not include in the first generated alert.

## 2. Evidence
- Synthetic event timestamps: 2026-01-01 00:00:00 through 00:00:25 UTC.
- Source and target were consistent across all six SSH failures.
- The recorded result is a detection threshold crossing, **not** proof of password guessing or an account compromise.
- Correlated successful logons, SSH daemon process information, EDR telemetry and user context are **not present** in the dataset.

## 3. Investigation workflow
1. Validate timestamps, event collection and source/target identity.
2. Review the SSH events before and after the alert window, including potential successes.
3. Confirm whether the originating host is an approved scanner, administrator or automation platform.
4. Investigate affected accounts, source host ownership, geolocation where appropriate, and endpoint telemetry.
5. Escalate for containment only with organizational authority and corroborating evidence.

## 4. Splunk reproduction
See `splunk/ssh_bruteforce.spl` and `splunk/ssh_investigation.spl`. These are **illustrative searches** intended for a Splunk lab after JSONL ingestion and field extraction. **They have not been executed in a connected Splunk instance.**

**Important:** The SPL uses one-minute fixed time buckets, whereas the Python script uses a sliding 60-second window. Their results can differ at minute boundaries. A complete implementation should align detection windows and validate this behavior on larger datasets.

## 5. Assessment and disposition
**Disposition:** Unconfirmed suspicious activity, needs additional authentication and endpoint evidence.  
**Severity:** Low-to-medium *illustrative triage priority*, not a production assessment.  
**Recommended action:** Document the finding, gather adjacent logs and escalate according to an established SOC playbook. No actual host isolation or account blocking was performed.

## 6. Limitations
All events are synthetic, no live SIEM or EDR data is involved, the alert source is not independently verified, and the sample lacks successful logon events. No attacker attribution is possible.

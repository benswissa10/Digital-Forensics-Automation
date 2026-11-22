#!/usr/bin/env python3
"""Offline SOC alert detection on synthetic JSONL events; no network actions."""
import argparse
import ipaddress
import json
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

TYPES = {"ssh_failure", "tcp_syn", "arp_observation"}

def read_events(path):
    events = []
    for number, line in enumerate(Path(path).read_text(encoding="utf-8").splitlines(), 1):
        if not line.strip():
            continue
        try:
            event = json.loads(line)
            if not isinstance(event, dict) or event.get("type") not in TYPES:
                raise ValueError("unrecognized event type")
            timestamp = datetime.fromisoformat(event["timestamp"].replace("Z", "+00:00"))
            if timestamp.tzinfo is None:
                raise ValueError("timestamp must include timezone")
            event["_time"] = timestamp.astimezone(timezone.utc)
            if event["type"] in ("ssh_failure", "tcp_syn"):
                ipaddress.ip_address(event["src_ip"])
                ipaddress.ip_address(event["dst_ip"])
            else:
                ipaddress.ip_address(event["ip"])
                if not event.get("mac"):
                    raise ValueError("missing MAC")
            events.append(event)
        except (ValueError, KeyError, TypeError, json.JSONDecodeError) as error:
            raise ValueError(f"Line {number}: {error}") from error
    return sorted(events, key=lambda event: event["_time"])

def detect(events, ssh_threshold=5, syn_threshold=10, window_seconds=60):
    alerts = []
    for kind, threshold, name in [
        ("ssh_failure", ssh_threshold, "Repeated SSH login failures"),
        ("tcp_syn", syn_threshold, "High SYN volume (possible flood)"),
    ]:
        groups = defaultdict(list)
        for event in events:
            if event["type"] == kind:
                groups[(event["src_ip"], event["dst_ip"])].append(event["_time"])
        for (src, dst), times in sorted(groups.items()):
            start = 0
            for end, timestamp in enumerate(times):
                while (timestamp - times[start]).total_seconds() > window_seconds:
                    start += 1
                count = end - start + 1
                if count >= threshold:
                    alerts.append({
                        "rule": name, "source": src, "target": dst,
                        "count": count, "window_seconds": window_seconds,
                        "first_seen": times[start].isoformat(),
                        "last_seen": timestamp.isoformat()
                    })
                    break

    mappings = defaultdict(set)
    for event in events:
        if event["type"] == "arp_observation":
            mappings[event["ip"]].add(event["mac"].lower())
    for address, macs in sorted(mappings.items()):
        if len(macs) > 1:
            alerts.append({
                "rule": "ARP IP-to-MAC mapping changed",
                "ip": address, "observed_macs": sorted(macs),
                "note": "May be legitimate; verify DHCP and switch telemetry."
            })
    return alerts

def main():
    parser = argparse.ArgumentParser(description="Offline SOC detection of synthetic events")
    parser.add_argument("events", type=Path)
    parser.add_argument("--ssh-threshold", type=int, default=5)
    parser.add_argument("--syn-threshold", type=int, default=10)
    parser.add_argument("--window-seconds", type=int, default=60)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if min(args.ssh_threshold, args.syn_threshold, args.window_seconds) <= 0:
        parser.error("thresholds and window must be positive")
    try:
        events = read_events(args.events)
    except (ValueError, OSError) as error:
        parser.error(str(error))
    result = {"events_analyzed": len(events), "alerts": detect(
        events, args.ssh_threshold, args.syn_threshold, args.window_seconds)}
    report = json.dumps(result, indent=2) + "\n"
    if args.output:
        args.output.write_text(report, encoding="utf-8")
    else:
        print(report, end="")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())

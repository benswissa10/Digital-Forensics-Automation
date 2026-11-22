import json
import tempfile
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path
from detect import detect, read_events

BASE = datetime(2026, 1, 1, tzinfo=timezone.utc)

def event(t, kind, **properties):
    return {"timestamp": (BASE + timedelta(seconds=t)).isoformat(),
            "type": kind, **properties}

def parsed(events):
    return [{**row, "_time": datetime.fromisoformat(row["timestamp"])}
            for row in events]

class DetectionTests(unittest.TestCase):
    def test_three_alerts(self):
        rows = [event(i, "ssh_failure", src_ip="192.0.2.10", dst_ip="192.0.2.20")
                for i in range(5)]
        rows += [event(i, "tcp_syn", src_ip="198.51.100.1", dst_ip="192.0.2.20")
                 for i in range(10)]
        rows += [event(1, "arp_observation", ip="192.0.2.1", mac="aa:bb:cc:dd:ee:01"),
                 event(2, "arp_observation", ip="192.0.2.1", mac="aa:bb:cc:dd:ee:02")]
        self.assertEqual(len(detect(parsed(rows))), 3)

    def test_spaced_out_events_do_not_alert(self):
        rows = [event(i*70, "ssh_failure", src_ip="192.0.2.10", dst_ip="192.0.2.20")
                for i in range(5)]
        rows += [event(i*70, "tcp_syn", src_ip="192.0.2.10", dst_ip="192.0.2.20")
                 for i in range(10)]
        self.assertEqual(detect(parsed(rows)), [])

    def test_invalid_timestamp(self):
        with tempfile.TemporaryDirectory() as directory:
            file = Path(directory) / "bad.jsonl"
            file.write_text('{"type":"ssh_failure","timestamp":"invalid"}\n')
            with self.assertRaises(ValueError):
                read_events(file)

    def test_events_are_sorted(self):
        rows = [event(2, "ssh_failure", src_ip="192.0.2.3", dst_ip="192.0.2.4"),
                event(1, "ssh_failure", src_ip="192.0.2.3", dst_ip="192.0.2.4")]
        with tempfile.TemporaryDirectory() as directory:
            file = Path(directory) / "events.jsonl"
            file.write_text("\n".join(json.dumps(row) for row in rows))
            events = read_events(file)
            self.assertLess(events[0]["_time"], events[1]["_time"])

if __name__ == "__main__":
    unittest.main()

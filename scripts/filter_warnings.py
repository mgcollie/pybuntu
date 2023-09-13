import sys

warning_strings = [
    "WARNING! Cannot add firewall",
    "WARNING! Process '/usr/NX/bin/nxexec nxfwadd.sh",
    "WARNING! Failed setting priority",
    "NXSERVER WARNING! NXLocalSession: Cannot retrieve node socket for session",
]

def should_filter(value):
    return any(warning in value for warning in warning_strings)

for line in sys.stdin:
    if not should_filter(line):
        sys.stdout.write(line)
        sys.stdout.flush()

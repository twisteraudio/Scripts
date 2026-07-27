"""
Python network packet sniffer
A network sniffer tool using scapy, filter by connection type or interface type

Usage:
    python3 pacs.py -f              - filter by connection type
    python3 pacs.py -i              - filter by interface type
    python3 pacs.py -c              - number of packets to capture
"""

import argparse,time,subprocess
from scapy.all import sniff, IP

def main():
    parser = argparse.ArgumentParser(description="Python packet sniffer using scapy")
    parser.add_argument("-f", "--filter", help="Filter type: 'tcp', 'udp', etc.")
    parser.add_argument("-i", "--interface", help="Interface type")
    parser.add_argument("-c", "--count", type=int, help="Number of entries")

    args = parser.parse_args()

    sniff(filter=args.filter, iface=args.interface, count=args.count,prn=lambda x:x.summary())

IP_info = subprocess.check_output(['hostname', '-I']).decode('utf-8').strip()

#printing host IP to make dump easier to digest
print("IP info: ", IP_info)
print("Starting scan...")
time.sleep(1)

if __name__ == "__main__":
    main()

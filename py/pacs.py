#USE THIS FILE TO PASTE CODES INTO SO YOU CAN COPY THEM INTO OTHER PROJECTS

import argparse
from scapy.all import sniff, IP

def main():
    parser = argparse.ArgumentParser(description="Python packet sniffer using scapy")
    parser.add_argument("-f", "--filter", help="Filter type: 'tcp', 'udp', etc.")
    parser.add_argument("-i", "--interface", help="Interface type")
    parser.add_argument("-c", "--count", type=int, help="Number of entries")

    args = parser.parse_args()

    sniff(filter=args.filter, iface=args.interface, count=args.count,prn=lambda x:x.summary())

print("Starting scan...")

if __name__ == "__main__":
    main()

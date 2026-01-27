#packet sniffer

from scapy.all import sniff, IP

def packet_handler(packet):
    if IP in packet:
        src_ip = packet[IP].src
        dst_ip = packet[IP].dst
        print(f"Source IP: {src_ip}")
        print(f"Destination IP: {dst_ip}")
    packet.summary()

print("Starting scan...")

sniff(prn=packet_handler, store=False)

#!/bin/bash

#network monitor tool

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

GetNetInt() {
    local GetInterface=$(ip -br l | awk '$1 ~ "^(wl|wlan)" { print $1 }')

    echo -e "Interface: ${YELLOW}${GetInterface}${RESET}"
}

GetIP() {
    local GetIPInfo=$(ip route get 1 | awk '{print $7}' | head -1)

    echo -e "IPv4: ${GREEN}${GetIPInfo}${RESET}"
}

GetMac() {
    local GetMacAddy=$(cat /sys/class/net/*/address | grep -v '^00:00:00:00:00:00$')

    echo -e "MAC: ${GREEN}${GetMacAddy}${RESET}"
}

#ping local gateway, 8.8.8.8, burnie.com

PingGate() {
    local GetGate=$(ip route show default | awk '/default/ {print $3}')

    if [[ -z "$GetGate" ]]; then
        echo -e "${RED}No Gateway found..${RESET}"
    fi

    if ping -c 1 -W2 "$GetGate" &> /dev/null; then
        echo -e "Gateway: ${GREEN}${GetGate}${RESET} is reachable"
        return 0
    else 
        echo -e "Gateway: ${RED}${GetGate}${RESET} is not reachable"
    fi
}

PingGoogle() {
    local GetGoogle=8.8.8.8

    if [[ -z "$GetGoogle" ]]; then
        echo -e "${RED}No Google found..${RESET}"
    fi

    if ping -c 1 -W2 "$GetGoogle" &> /dev/null; then
        echo -e "Google: ${GREEN}${GetGoogle}${RESET} is reachable"
        return 0
    else 
        echo -e "Google: ${RED}${GetGoogle}${RESET} is not reachable"
    fi
}

PingBurnie() {
    local GetBurnie=$(dig +short burnie.com)

    if [[ -z "$GetBurnie" ]]; then
        echo -e "${RED}No Burnie found..${RESET}"
    fi

    if ping -c 1 -W2 "$GetBurnie" &> /dev/null; then
        echo -e "Burnie: ${GREEN}${GetBurnie}${RESET} is reachable"
        return 0
    else 
        echo -e "Burnie: ${RED}${GetBurnie}${RESET} is not reachable"
    fi
}

main() {
    printf '%8s NETWORK DASHBOARD %8s\n' | tr ' ' '-'
    echo
    GetNetInt
    GetMac
    echo
    GetIP
    PingGate
    PingGoogle
    PingBurnie
}

main

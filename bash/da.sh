#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

GetTime() {
    local GetLocalTime=$(date +"%Y-%m-%dT%H:%M:%S%z")
    local GetUTCTIme=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo -e "Local: ${YELLOW}${GetLocalTime}${RESET}"
    echo -e "UTC: ${YELLOW}${GetUTCTIme}${RESET}"
}

GetIP() {
    local GetIPInfo=$(ip route get 1 | awk '{print $7}' | head -1)

    echo -e "IPv4: ${GREEN}${GetIPInfo}${RESET}"
}

GetDrive() {
    df -h | grep -E '^(Filesystem|/)' | awk '{
        if (NR==1) print;
        else {
            use = $5; gsub(/%/, "", use);
            if (use + 0 > 85) printf "\033[31m%s\033[0m\n", $0;
            else print $0;
        }
    }'
}

GetNetStat() {
    local ip=$(hostname -i | awk '{print $1}')

    local GetNetstatInfo=$(netstat -tlpn 2>/dev/null | grep -w "$ip")

    if [[ -z "$GetNetstatInfo" ]]; then
        echo "No listening ports found for IP: $ip" >&2
    else
        echo -e "$GetNetstatInfo"
    fi
}

echo -e "${BOLD}${BLUE}--- DASHBOARD ---${RESET}"
GetTime
GetIP
echo
GetDrive
echo
GetNetStat

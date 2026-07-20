#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
BOLD='\e[1m'
RESET='\e[0m'

diceroll() {
    roll=$(( (SRANDOM % 20) + 1 ))
}

life=0
death=0
count=1

while [ "$count" -le 5 ]; do
    diceroll
    
    if [ $roll -eq 1 ]; then
        echo -e "${YELLOW}$roll${RESET}: ${RED}MEGADEAD${RESET}"
        ((death += 2))
    elif [ $roll -eq 20 ]; then
        echo -e "${YELLOW}$roll${RESET}: ${GREEN}SUPERALIVE${RESET}"
        ((life += 2))
    elif [ $roll -gt 10 ]; then
        echo -e "${YELLOW}$roll${RESET}: Alive"
        ((life++))
    else 
        echo -e "${YELLOW}$roll${RESET}: Dead"
        ((death += 1))
    fi
    ((count++))
done

if [ "$death" -gt 2 ]; then
    echo -e "${RED}You died...${RESET}"
elif [ $life -gt 3 ]; then
    echo -e "${GREEN}YOU LIVE!${RESET}"
else
    echo -e "${GREEN}YOU LIVE!${RESET}"
fi

"""
System Dashboard
A quick cross-platform system information dashboard.

Usage:
    python3 dash.py
    python3 dash.py -l                  - Loop every 5 seconds
    python3 dash.py -o output.log       - Write to file (txt, csv, log)
    python3 dash.py -l -o output.log    - Loop + write to file

"""

import argparse
import os
import platform
import re
import shutil
import socket
import string
import subprocess
import time
from typing import List, Optional
from datetime import datetime, timezone, timedelta

class Color:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    LIGHTGRAY = '\033[37m'
    GRAY = '\033[90m'
    LIGHTRED = '\033[91m'
    LIGHTGREEN = '\033[92m'
    LIGHTYELLOW = '\033[93'
    LIGHTBLUE = '\033[94m'
    LIGHTMAGENTA = '\033[95m'
    LIGHTCYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033e[1m'
    ITALIC = '\033[3m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

#reverse ansi color text for file output
def anti_ansi(text):
    ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    return ansi_escape.sub('', text)

#prepare for file output
def print_output(message, file_handle=None):
    print(message)
    if file_handle:
        clean_message = anti_ansi(message)
        file_handle.write(clean_message + '\n')
        file_handle.flush()

def clear_scn():
    subprocess.run(['cls'] if os.name == 'nt' else ['clear'], shell=os.name == 'nt')

#getting local and UTC time
def thetime(file_handle=None):

    #system uptime
    uptime_seconds = time.monotonic()
    uptime_str = str(timedelta(seconds=uptime_seconds))
    print_output(f"{Color.LIGHTCYAN}System uptime: {uptime_str}{Color.END}", file_handle)

    print_output(f"{Color.BLUE}Local time: {Color.END}" + str(datetime.now()), file_handle)
    print_output(f"{Color.BLUE}UTC time: {Color.END}" + str(datetime.now(timezone.utc)), file_handle)

#getting drive space info
def drivespace(file_handle=None,drives: Optional[List[str]] = None):

    current_os = platform.system()

    if drives is None:
        if current_os == 'Windows':
            drives = []
            for letter in string.ascii_uppercase:
                drive = f"{letter}:/"
                try:
                    shutil.diskusage(drive)
                    drives.append(drive)
                except OSError:
                    continue
        else:
            drives = ["/"]
            
    if not drives:
        print_output("No drives found...", file_handle)
        return
    
    for drivepath in drives:
        try:
            total, used, free = shutil.disk_usage(drivepath)
            
            total_gb = total / (1024 ** 3)
            free_gb = free / (1024 ** 3)
            used_gb = used / (1024 ** 3)
            
            print_output(f"Drive: {drivepath}", file_handle)
            print_output(f"{Color.LIGHTGREEN}Total: {total_gb:.2f} GB{Color.END}", file_handle)
            print_output(f"{Color.LIGHTGREEN}Free:  {free_gb:.2f} GB{Color.END}", file_handle)
        except OSError as e:
            print_output(f"Error accessing {drivepath}: {e}", file_handle)
        except Exception as e:
            print_output(f"{drivepath} - Unexpected error: {e}", file_handle)

#getting IPv4 address
def IPinfo(file_handle=None):

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    try:
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except:
        IP = '127.0.0.1'
    finally:
        s.close()

    #ping resulting IP to see if it is pingable
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    command = ['ping', param, '1', IP]

    try:
        response = subprocess.run(command, capture_output=True, timeout=2)
        if response.returncode == 0:
            print_output(f"{Color.GREEN}{IP} is Online{Color.END}", file_handle)
        else:
            print_output(f"{Color.RED}Offline...{Color.END}", file_handle)
    except subprocess.TimeoutExpired:
        print_output(f"Timeout Error...", file_handle)
    except Exception as e:
        print_output(f"Error when pinging {IP}", file_handle)

def sysInfo(file_handle=None):

    print_output('-' *8 + ' SYSTEM DASHBOARD ' + '-' *8, file_handle)
    thetime(file_handle)
    IPinfo(file_handle)
    drivespace(file_handle)
    print_output('-' * 34, file_handle)

def run_loop(file_handle=None):
    while True:
        clear_scn()
        sysInfo(file_handle)
        time.sleep(5)

def main():

    parser = argparse.ArgumentParser(description = "Python System Dashboard")
    parser.add_argument("-l", "--loop", action="store_true", help="Loop dashboard")
    parser.add_argument("-o", "--outfile",type=str, metavar="FILENAME", help="Output to file")
    args = parser.parse_args()

    file_handle = None

    try:
        if args.outfile:
            file_handle = open(args.outfile, 'a')
            print(f"Writing to {args.outfile}...")

        if args.loop:
            run_loop(file_handle)
        else:
            sysInfo(file_handle)

    except KeyboardInterrupt:
        print_output(f"{Color.YELLOW}\nYou pressed Ctrl+C, exiting...{Color.END}", file_handle)
        
    finally:
        if file_handle:
            file_handle.close()
            print(f"{Color.GREEN}File {args.outfile} written successfully{Color.END}")

if __name__ == "__main__":
    main()

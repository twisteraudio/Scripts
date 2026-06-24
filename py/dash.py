"""
System Dashboard
A quick cross-platform system information dashboard.

Usage:
    python3 dash.py
    python3 dash.py -l                  # Loop every 5 seconds
    python3 dash.py -o output.log       # Write to file
    python3 dash.py -l -o output.log    # Loop + write to file

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

#color text
CRED = '\033[91m'
CGREEN = '\033[92m'
CYELLOW = '\033[93m'
CBLUE = '\033[94m'
CEND = '\033[0m'

output_file = None

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

    print_output(CBLUE + "Local time: " + str(datetime.now()) + CEND, file_handle)
    print_output(CBLUE + "UTC time: " + str(datetime.now(timezone.utc)) + CEND, file_handle)

    #system uptime
    uptime_seconds = time.monotonic()
    uptime_str = str(timedelta(seconds=uptime_seconds))
    print_output(f"System uptime: {uptime_str}", file_handle)

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
            print_output(f"  Total: {total_gb:.2f} GB", file_handle)
            print_output(f"  Free:  {free_gb:.2f} GB", file_handle)
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
            print_output(CGREEN + f"{IP} is Online" + CEND, file_handle)
        else:
            print_output(CRED + "Offline..." + CEND, file_handle)
    except subprocess.TimeoutExpired:
        print_output("Timeout Error...", file_handle)
    except Exception as e:
        print_output(f"Error when pinging {IP}", file_handle)

def sysInfo(file_handle=None):

    print_output('-' *8 + ' DASHBOARD ' + '-' *8, file_handle)
    thetime(file_handle)
    drivespace(file_handle)
    IPinfo(file_handle)
    print_output("")

def run_loop(file_handle=None):
    while True:
        clear_scn()
        sysInfo(file_handle)
        time.sleep(5)

def main():

    global output_file

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
        print_output("\nYou pressed Ctrl+C, exiting...", file_handle)
    finally:
        if file_handle:
            file_handle.close()
            print(f"File {args.outfile} written successfully")

if __name__ == "__main__":
    main()

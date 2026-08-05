"""
Python Random Record Selection
Outputs random selection of rows from record collection spreadsheet

Reason: I wanted to have fun with record collection and use python to randomly select records to listen to

Usage:
    python3 rcran.py                                       - default (outputs 3 selections)
    python3 rcran.py -p '/path/to/file' -c 5               - outputs X count selections
    python3 rcran.py -p '/path/to/file' -q "SOME_QUERY"    - query the spreadsheet
"""

import pandas as pd
import os, time, sys, subprocess, argparse

parser = argparse.ArgumentParser(description = "Record Collection Parser")
parser.add_argument("-c", "--count", type=int, help="Number of entries")
parser.add_argument("-q", "--query", type=str, help="Query Spreadsheet")
parser.add_argument("-p", "--path", type=str, required=True, help="Path to file")
args = parser.parse_args()

#color text
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
    LIGHTYELLOW = '\033[93m'
    LIGHTBLUE = '\033[94m'
    LIGHTMAGENTA = '\033[95m'
    LIGHTCYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    ITALIC = '\033[3m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

def clear_scn():

    subprocess.run(['cls'] if os.name == 'nt' else ['clear'], shell=os.name == 'nt')

#loading screen
def load_scn():

    clear_scn()
    print(f"{Color.YELLOW}Loading selection...{Color.END}")
    time.sleep(1)

#select random selections
def pd_sample():

    df = pd.read_excel(args.path, usecols = 'B:C')
    print(f"{Color.GREEN}*{Color.END}" * 75)
    print(f"{Color.LIGHTCYAN}{df.sample(args.count).to_string(index=False)}{Color.END}")
    print(f"{Color.GREEN}*{Color.END}" * 75)

#query spreadsheet
#df.query()
def pd_query():

    df = pd.read_excel(args.path, usecols = 'A:E')
    try:
        query = df.query(args.query).to_string(index=False)
        
        print(f"{Color.LIGHTCYAN}{query}{Color.END}")

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

def main():

    if args.count:
        try:
            load_scn()
            pd_sample()
        finally:
            print(f"{Color.GREEN}Selection Complete{Color.END}")

    if args.query:
        try:
            load_scn()
            pd_query()
        finally:
            print(f"{Color.GREEN}Selection Complete{Color.END}")

if __name__ == "__main__":
    main()

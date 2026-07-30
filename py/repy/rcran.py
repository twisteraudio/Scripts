"""
Python Random Record Selection
Outputs random selection of rows from record collection spreadsheet

Reason: I wanted to have fun with record collection and use python to randomly select records to listen to

Usage:
    python3 rcran.py    - default (outputs 3 selections)
    python3 rcran.py -c 5   - outputs X count selections
    python3 rcran.py -q SOME_QUERY  - query the spreadsheet
"""
import pandas as pd
import os
import time
import sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description = "Record Collection Parser")
parser.add_argument("-c", "--count", type=int, help="Number of entries")
parser.add_argument("-q", "--query", type=str, help="Query Spreadsheet")
args = parser.parse_args()

#color text
CRED = '\033[91m'
CGREEN = '\033[92m'
CYELLOW = '\033[93m'
CBLUE = '\033[94m'
CEND = '\033[0m'


def clear_scn():
    subprocess.run(['cls'] if os.name == 'nt' else ['clear'], shell=os.name == 'nt')

#loading screen
def load_scn():
    clear_scn()
    print(CYELLOW + "Loading selection..." + CEND)
    time.sleep(1)

#select random selections
def pd_sample():

    df = pd.read_excel('recol.xlsx', usecols = 'B:C')
    print(CGREEN + "*" * 75 + CEND)
    print(CGREEN + df.sample(args.count) + CEND)
    print(CGREEN + "*" * 75 + CEND)

#query spreadsheet
#df.query()
def pd_query():

    df = pd.read_excel('recol.xlsx', usecols = 'A:E')
    try:
        query = df.query(args.query)
        
        print(query)

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    if args.count:
        try:
            load_scn()
            pd_sample()
        finally:
            print(CGREEN + "Selection Complete" + CEND)

    if args.query:
        try:
            load_scn()
            pd_query()
        finally:
            print(CGREEN + "Selection Complete" + CEND)

if __name__ == "__main__":
    main()
"""
Python Google Dork for Job Postings
Description: Opens default web browser and searches using Google dorking to find job postings

Usage:
    python3 dork.py -s 'stringhere'          
        - string search for particular worded postings
    python3 dork.py -m 7                     
        - filters by any postings after -m days
    python3 dork.py -s 'stringhere' -m 7     
        - most common usage, search for particular 
"""

import argparse
import time
import webbrowser
import urllib.parse
from pathlib import Path
from datetime import date, timedelta

parser = argparse.ArgumentParser(description = "Python Google Dorking")
parser.add_argument("-s", "--search",  help="Keyword search")
parser.add_argument("-m", "--minus", help="Minus -m days")
args = parser.parse_args()

#COLORS!!! Wow!!
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
    LIGHTLUE = '\033[94m'
    LIGHTMAGENTA = '\033[95m'
    LIGHTCYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033e[1m'
    ITALIC = '\033[3m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

def getDate():

    result = (date.today() - timedelta(days=5)).strftime("%Y-%m-%d")
    return result

def getContent(path: str) -> str:
    file_path = Path(path)
    if not file_path.exists():
        raise FileNotFoundError(f"File not found: {path}")
    
    with open(file_path, encoding="utf-8") as f:
        lines = [line.strip() for line in f if line.strip()]
    
    return " ".join(lines)

def getQuery():
    sites = getContent("sites.txt")
    location = getContent("location.txt")

    query = f"{sites} {args.search} AND {location}".strip()

    return query

def getURL():
    dateSub = getDate()
    getSearch = getQuery()
    query = getSearch + " after:" + dateSub
    encoded_query = urllib.parse.quote_plus(query)
    url = f"https://google.com/search?&q={encoded_query}"

    print(f"{Color.LIGHTCYAN}Query sent: {Color.END}" + url)

    try:
        webbrowser.open_new(url)
    except webbrowser.Error as e:
        print(f"Browser error occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        print(f"{Color.LIGHTGREEN}Query complete{Color.END}")

def main():

    print(f"{Color.YELLOW}Starting browser...{Color.END}")
    time.sleep(1)

    getURL()

if __name__ == "__main__":
    main()

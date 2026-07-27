"""
Round timestamp to the nearest 15 minute marker

Usage:
    python3 timernd.py -t "7/20/2026 7:18:11"
"""

import pandas as pd, argparse

parser = argparse.ArgumentParser(description = "Copy timestamp you would like to round to the nearest 15 minutes")
parser.add_argument("-t", "--time", help="Timestamp you would like to round")
args = parser.parse_args()

ts = pd.Timestamp(args.time)

print(ts.round("15min"))

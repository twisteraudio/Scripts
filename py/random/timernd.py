#goal: round timestamp for clock in/out to nearest quarter hour

import pandas as pd, argparse

parser = argparse.ArgumentParser(description = "Copy timestamp you would like to round to the nearest 15 minutes")
parser.add_argument("-t", "--time", help="Timestamp you would like to round")
args = parser.parse_args()

ts = pd.Timestamp(args.time)

print(ts.round("15min"))

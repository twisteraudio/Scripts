"""
Weather checker
Check the weather in a location using wttr.in

Usage:
    python3 wea.py -loc Austin
    Python3 wea.py -loc 'San Francisco'
"""

import argparse, os

parser = argparse.ArgumentParser(description = "Python Weather app using wttr.in as base")
parser.add_argument("-loc", help="Location you would like to use")
args = parser.parse_args()

print(os.system("curl wttr.in/" + args.loc + "?format=3"))

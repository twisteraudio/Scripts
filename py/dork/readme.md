# Python Dork

Welcome to the Python version of Seo_Dork found in /ps1.

This script opens the default web browser and conducts a search for job postings within the locations set by location.txt.

The goal of this script is simple, recreate seo_dork.ps1 in Python. This involved converting the following processes:

- Taking data from a txt file and setting that as a string variable

- Taking the current date and subtracting N days via parameter

- Accepting user input via parameter for search query

- Opening default webbrowser to begin search query

# Usage

While the script will run with no parameters given, it makes a better experience to use the parameters

    python3 dork.py                          
        - default, opens browser and searches for any job postings in area
    
    python3 dork.py -s 'stringhere'          
        - string search for particular worded postings
    
    python3 dork.py -m 7                     
        - filters by any postings after -m days
    
    python3 dork.py -s 'stringhere' -m 7     
        - most common usage, search for particular 

# Purpose

In the age of ghost jobs and outdated job searching sites, it is better to research harder than just browsing Indeed or LinkedIn to scrape job postings that may already be closed. This script is inspired by a Reddit post about using Google dorking to search job postings in the area.

# [Disclaimer]

This script is for educational/ethical purposes only. This script utilizes Google dorking and may trigger query blocks if program is abused or automated heavily. Please always exercise cuation when running scripts and review all code. Don't ruin a fun thing. For real.
Welcome to Seo_Dork!

This powershell script utilizes Google dorking to search for Application Tracking Systems and filter based on keywords and locations.

DISCLAIMER
This script was developed in Linux and is being updated to detect operating systems and running normally. As of now, edit the firefox line to work with Windows or MacOS.

Directions:
Please look through the script to get an idea of how it works. If no parameter is set, it will default to the -basic flag. The use of -min must be used, else it will break the script since it will search based on today's date and give an empty search result.

Edit basic.txt to search for the keywords in titles you would like to search for. Same for location.txt. If any new ATS sites come around, please update the sites.txt to include that new addition.

Example for basic.txt or location.txt:
("asdf" OR "blarg") << fill in the quotes with what you would like to search for.

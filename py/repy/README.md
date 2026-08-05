# Record Python (repy)

This is a personal project that's been worked on for a while. The goal was to use python to randomly select a record from the spreadsheet. Then it snowballed into trying to query from python and to give a set selection of random selections.

This folder may be updated as new features or ideas come around.

# Contents

rcref.xlsx      - xlsx of record collection
rcran.py        - python script to parse through rcref.xlsx
    -p, --path  - [Required] path to file
    -c, --count - returns a count of random selections from spreadsheet
    -q, --query - queries the spreadsheet using Pandas' query function

# Examples

    Select 10 random records from collection
    python3 -p '/path/to/rcref.xlsx' -c 10

    Search for Artist Foo Fighters
    python3 -p '/path/to/rcref.xlsx' -q "Artist == 'Foo Fighters'"

    Search for Albums with 'Best' in the title
    python3 -p '/path/to/rcref.xlsx' -q "Album.str.contains('Best')"

    Search for most recent entry to collection
    python3 -p '/path/to/rcref.xlsx' -q "Timestamp == Timestamp.max()"

# [Disclaimer]

While the script and spreadsheet are harmless, please use caution and review all commands being run before use.
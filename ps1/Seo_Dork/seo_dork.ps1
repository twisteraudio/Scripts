#goal: use google dorks to give results of job postings within input parameter
#must be used as non-sudo

param(
    [parameter(Mandatory=$true)]
    [string]$min,
    [switch]$q,
    [switch]$basic,
    [switch]$sec
)

#get-date -format "yyyy-MM-dd"
#$DateNow = get-date -format "yyyy-MM-dd"

#getting date from yesterday, filtering results from input parameter
$Date_min1 = (get-date).AddDays(-$min) | get-date -format "yyyy-MM-dd"

#What sites the search will use
$sites = get-content -path "sites.txt" -raw

#Position Keywords
if (-not $basic -or $sec) {
    $positions = read-host "What position would you like to search?"
}
if ($basic) {
    $positions = get-content -path "basic.txt" -raw
}
if ($sec) {
    $positions = get-content -path "sec.txt" -raw
}

#Location Keywords
$location = get-content -path "location.txt" -raw

if ($q) {
    $search = "(inurl:'careers' OR 'jobs')"
}
else {
    $search = $sites
}

firefox --search "$search $positions AND $location after:$Date_min1"

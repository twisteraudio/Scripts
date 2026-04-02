#Local Time to UTC converter
#usecase: for any NWS or other related postings that utilize UTC


#example: (get-date "2021-08-26 16:44:42").ToLocalTime()
#(Get-Date).ToUniversalTime().ToString('u') | get-date -format "HH:mm:ss"

#parameter to take the time you would like to convert
#24H format: 1PM == 13

param(
    [parameter(Mandatory=$true)]
    [int]$t,
    [switch]$l
)

$GD_Today = get-date -format "yyyy-MM-dd"

#-l will covert input UTC to local time
if ($l) {
    $convert = (get-date ($GD_Today + ' ' + $t + ':00:00')).ToLocalTime().ToString('u')
}
#takes relative local time input and converts to relative UTC
else {
    $convert = (get-date ($GD_Today + ' ' + $t + ':00:00')).ToUniversalTime().ToString('u')
}

$convert

#morning dashboard routine
#goal: create a script to run at the start of the day#>

param (
    [switch]$n,
    [switch]$p
)

#get system uptime
$uptime = (get-uptime -Since).ToString()

function get-thetime {

    #getting time in UTC and local
    $getutc = (get-date).ToUniversalTime().ToString('u')
    $getcst = (get-date).ToLocalTime()

    write-host "The current UTC time is $getutc" -foregroundcolor Cyan
    write-host "The current local time is $getcst" -foregroundcolor magenta
}

function get-weather {

    #checking OS, Windows requires useragent to work in terminal
    if ($IsWindows) {
        $part1 = 'http://wttr.in/'
        $part2 = '?format=3'
        (curl ($part1 + $part2) -useragent 'curl').content
    }
    else {
        curl http://wttr.in/?format=3
    }
}

function get-driveinfo{
    get-psdrive | foreach-object {

        #selecting the drive(s) w/ 0gb space
        if ($_.free -gt 1) {
            write-host $_.name 'has' ([math]::Round($_.Free / 1GB, 2)) 'gb remaining' -foregroundcolor green
        }
    }
}

function get-top {

    #top clone, gets top 10 running processes by CPU usage
	get-process | 
	sort-object -des cpu | 
	select-object -f 10 |
	format-table
}

function get-IPinfo {

    #get IPv4 address
    if ($IsWindows) {
        $IPinfo = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"}).IPAddress
    }
    elseif ($IsLinux) {
        $IPinfo = hostname -I
    }
    $IPinfo
}

if (-not $p -or $n) {
    try {
        get-weather
        get-thetime
        write-host "System has been booted since: $uptime" -foregroundcolor Yellow
        get-IPinfo
        get-driveinfo
        get-top
    }
    catch {
        write-warning "Error in script..."
    }
}

if ($n) {
    try {
        get-thetime
        write-host "System has been booted since: $uptime" -foregroundcolor Yellow
        get-IPinfo
        get-driveinfo
        get-top
    }
    catch {
        write-warning "Error at -n switch...Something went wrong"
    }
}

if ($p) {
    try {
        get-IPinfo
        get-thetime
        get-weather
        get-driveinfo
    }
    catch {
        write-warning "Error at -p switch...Something went wrong"
    }
}

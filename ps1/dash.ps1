<#
.Synopsis
    Gather quick system information
.DESCRIPTION
    Gathers information on system and network in a quick dashboard
    Can be looped or piped to file output via parameter
.PARAMETER n
    Network flag, gathers network related information
.PARAMETER p
    Profile flag, gathers quick info for local profile
.PARAMETER l
    Looper, loops the dashboard for continuous minitoring
.PARAMETER o
    Outputs information to txt file
#>

param(
    [switch]$n,
    [switch]$p,
    [switch]$t,
    [switch]$l,
    [switch]$o
)

$uptime = (get-uptime -Since).ToString()

function get-test {
    write-host "this script had a testing function thrown in..."
}

function get-thetime {

    #getting time in UTC and local
    $getutc = (get-date).ToUniversalTime().ToString('u')
    $getcst = (get-date).ToLocalTime()

    write-host "The current UTC time is $getutc" -foregroundcolor Cyan
    write-host "The current local time is $getcst" -foregroundcolor magenta
}

function get-weather {

    #web request to retrieve weather info
    Invoke-WebRequest -Uri "https://wttr.in/?format=3" -UseBasicParsing |
    Select-Object -ExpandProperty Content
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
        $IPinfo = (Get-NetIPAddress -AddressFamily IPv4 | 
        Where-Object {$_.IPAddress -notlike "127.*"}).IPAddress
    }
    elseif ($IsLinux) {
        $IPinfo = hostname -I
    }
    [string]$IPinfo
}

function get-dashboard {

    if ($t) {
        try {
            write-host "testing"
        }
        catch {
            write-warning "The test flag has issues..."
        }
    }

    if ($n) {
        try {
            clear-host
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
            clear-host
            get-IPinfo
            get-thetime
            get-weather
        }
        catch {
            write-warning "Error at -p switch...Something went wrong"
        }
    }
}

if ($l) {
    try{
        while(1) {
            get-dashboard; sleep 5
        }
    }
    finally {
        write-host " KeyBoardInterrupt: Ctrl+C" -foregroundcolor yellow
    }
}

elseif ($o) {
    try {
    #dirty but quick way to get all output to a file
    #because I wanted the color output still for terminal but being able to output everything to file
    start-transcript -path "testing.txt" -Force | out-null
    get-dashboard
    stop-transcript | out-null
    }
    catch {
        write-warning "Error exporting file..."
    }
}

else {
    get-dashboard
}

<#
.SYNOPSIS
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
    [switch]$l,
    [string]$o
)

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

$script:ErrorLog = @()
$script:WarningLog = @()

$PSStyle.OutputRendering = 'Host'

function Write-Color {
    param(
        [string]$Message,
        [string]$ForegroundColor = 'White'
    )

    $color = switch ($ForegroundColor) {
        'Red'    { $PSStyle.Foreground.Red }
        'Green'  { $PSStyle.Foreground.Green }
        'Yellow' { $PSStyle.Foreground.Yellow }
        'Blue'   { $PSStyle.Foreground.Blue }
        default  { $PSStyle.Foreground.White }
    }
    
    Write-Output "${color}${Message}$($PSStyle.Reset)"
}

function Add-ErrorLog {
    param(
        [string]$Functionname,
        [string]$ErrorMessage,
        [string]$Critical
    )

    $timestamp = get-date -format 'yyyy-MM-dd HH:mm:ss'
    $logentry = "[$timestamp] $FunctionName : $ErrorMessage"

    $script:ErrorLog += $logentry

    if ($Critical) {
        write-host "Critical Error: $ErrorMessage" -foregroundcolor red
    }
}

function Add-WarningLog {
    param(
        [string]$FunctionName,
        [string]$Message
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logEntry = "[$timestamp] $FunctionName`: $Message"
    
    $script:WarningLog += $logEntry
    Write-Host $logEntry -ForegroundColor Yellow
}

function Get-Start {
    Write-Color ("-"*8 + " SYSTEM DASHBOARD " + "-"*8) -ForegroundColor default
}

function Get-TheTime {

    $GetUptime = (get-uptime -Since).ToString()

    write-color "System booted since: $GetUptime"

    #getting time in UTC and local
    $GetUTC = (get-date).ToUniversalTime().ToString('u')
    $GetLocal = (get-date).ToLocalTime().ToString('u')

    write-color "UTC time: $GetUTC" -ForegroundColor Green
    write-color "Local time: $GetLocal" -ForegroundColor Green
}

function Get-Weather {
    try {
        $response = Invoke-WebRequest -Uri "https://wttr.in/?format=3" `
            -UseBasicParsing `
            -ErrorAction Stop `
            -TimeoutSec 5

        Write-Color "Weather: $($response.Content)" -ForegroundColor Green
    }
    catch [System.Net.Http.HttpRequestException] {
        Add-WarningLog -FunctionName "Get-Weather" -Message "Weather service unreachable"
    }
    catch [System.TimeoutException] {
        Add-WarningLog -FunctionName "Get-Weather" -Message "Weather service request timed out"
    }
    catch {
        Add-WarningLog -FunctionName "Get-Weather" -Message "Failed to retrieve weather: $($_.Exception.Message)"
    }
}

function Get-DriveInfo {
    param(
        [switch]$IncludeNonFileSystem
    )

    $drives = Get-PSDrive -ErrorAction SilentlyContinue
    
    if (-not $drives) {
        Write-Warning "No drives found"
        return
    }

    foreach ($drive in $drives) {

        if ($drive.Provider.Name -ne 'FileSystem' -and -not $IncludeNonFileSystem) {
            continue
        }

        if ($null -eq $drive.Free -or $null -eq $drive.Used) {
            continue
        }

        if ($drive.Free -gt 1GB) {
            $freeGB = [math]::Round($drive.Free / 1GB, 2)
            $usedGB = [math]::Round($drive.Used / 1GB, 2)
            write-color "$($drive.Name) $freeGB GB free | $usedGB GB used"
        }
    }
}

function Get-Top {

    #top clone, gets top 10 running processes by CPU usage
	get-process | 
	sort-object -des cpu | 
	select-object -f 10 |
	format-table
}

function Get-IPInfo {
    try {
        $IPinfo = $null

        if ($IsWindows) {
            $IPinfo = @(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop | 
                Where-Object { $_.IPAddress -notlike "127.*" } | 
                Select-Object -ExpandProperty IPAddress)
        }
        elseif ($IsLinux -or $IsMacOS) {
            $IPinfo = @(ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}' 2>$null)
        }

        if ($null -ne $IPinfo -and $IPinfo.Count -gt 0) {
            Write-Color "IPv4 Address: $IPinfo" -ForegroundColor Yellow
        }
        else {
            Write-Color "No IPv4 addresses found" -ForegroundColor Yellow
        }
    }
    catch {
        Add-WarningLog -FunctionName "Get-IPInfo" -Message "Failed to retrieve IP information: $($_.Exception.Message)"
    }
}

function Get-Dashboard {

    try {
        clear-host

        if ($n) {
            Get-Start
            Get-TheTime
            Get-IPinfo
            Get-DriveInfo
            Get-Top
            return
        }

        if ($p) {
            Get-Start
            get-IPinfo
            Get-TheTime
            Get-Weather
            return
        }

        Get-Start
        Get-TheTime
        get-IPinfo
        Get-DriveInfo
    }

    catch {
        Add-ErrorLog -FunctionName "Get-Dashboard" -ErrorMessage $_.Exception.Message -Critical
    }
}

if ($l) {

    try{
        while($true) {
            Get-Dashboard -l:$false
            start-sleep -seconds 5
        }
    }

    finally {
        write-host " KeyBoardInterrupt: Ctrl+C" -foregroundcolor yellow
    }
}

elseif ($o) {
    try {
        if ([string]::IsNullOrWhiteSpace($o)) {
            throw "Output path cannot be empty"
        }

        $outputPath = $o

        Write-Host "Generating dashboard output..." -ForegroundColor Cyan

        $consoleOutput = & {
            Get-Dashboard
        } 2>&1 | Out-String

        $consoleoutput

        if ($null -eq $consoleOutput -or $consoleOutput.Length -eq 0) {
            Write-Color "Warning: Dashboard output is empty" -ForegroundColor Yellow
        }

        $consoleOutput | Out-File -FilePath $outputPath -Encoding UTF8 -ErrorAction Stop

        Write-Color "Dashboard saved to: $outputPath" -ForegroundColor Green

        if ($script:WarningLog.Count -gt 0 -or $script:ErrorLog.Count -gt 0) {
            Write-Host ""
            Write-Color "=== Execution Summary ===" -ForegroundColor Yellow
            Write-Host "Warnings: $($script:WarningLog.Count)"
            Write-Host "Errors: $($script:ErrorLog.Count)"
        }
    }
    catch [System.IO.IOException] {
        Add-ErrorLog -FunctionName "FileOutput" -ErrorMessage "Cannot write to file: $($_.Exception.Message)" -Critical
    }
    catch [System.UnauthorizedAccessException] {
        Add-ErrorLog -FunctionName "FileOutput" -ErrorMessage "Access denied: $($_.Exception.Message)" -Critical
    }
    catch {
        Add-ErrorLog -FunctionName "FileOutput" -ErrorMessage $_.Exception.Message -Critical
    }
}

else {
    try {
        Get-Dashboard
    }
    catch {
        Add-ErrorLog -FunctionName "MainExecution" -ErrorMessage $_.Exception.Message -Critical
    }
}

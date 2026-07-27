<#
.SYNOPSIS
    PowerShell log parser
.DESCRIPTION
    Parses through system logs to quickly determine certain events
.PARAMETER ty
    Enter pattern type you would like to search for
    ie: Errors, Security, Auth, Login
.EXAMPLE
    .\log.ps1 -ty failed
    .\log.ps1 -ty 3301
#>

param(
    [parameter(Mandatory=$true)]
    [string]$ty
)

if ($IsLinux) {
    $logpath = '/var/log/auth.log'
}
elseif ($IsMac) {
    $logpath = '/var/log/system.log'
}
elseif ($IsWindows) {
    $logpath = '%SystemRoot%\System32\winevt\Logs'
}

get-content -path $logpath | select-string -pattern $ty

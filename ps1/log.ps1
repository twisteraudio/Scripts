#simple log file parser
#ty = type of pattern you would like to look for
#ie: error, security, auth, login, skiddiestuff

param(
    [parameter(Mandatory=$true)]
    [string]$ty
)

if ($IsLinux) {
    $logpath = '/var/log/syslog'
}
elseif ($IsMac) {
    $logpath = '/var/log/system.log'
}
elseif ($IsWindows) {
    $logpath = '%SystemRoot%\System32\winevt\Logs'
}

get-content -path $logpath | select-string -pattern $ty
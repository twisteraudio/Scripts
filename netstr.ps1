$netstr = (netsh wlan show interfaces) -match '^\s+Signal' -replace '^/s+Signal\s+:',''

while (1) {
    write-host $netstr -foregroundcolor cyan | format-table; sleep 1; clear
}

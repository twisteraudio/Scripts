#re-creating the 'top' command from linux environments

function get-top {
	gps | 
	sort-object -des cpu | 
	select -f 15 |
	format-table ; sleep 1; clear
}

$uptm = get-uptime -Since

while(1) {
	write-host "System was last booted: $uptm" | get-top
}

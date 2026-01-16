$global:life = 0

#d20 roll
function get-dice {
	$d20 = 1..20 | get-random
	if ($d20 -lt 10) {$global:life++; write-host "$d20" -foregroundcolor red}
	else {write-host "$d20" -foregroundcolor green}
}
clear-host

#roll dice 5 times
for ($i = 0; $i -lt 5; $i++) {
	write-progress -id 0 "roll $i"| 
	get-dice; sleep 1
}

#life check

if ($global:life -gt 2) {
	write-host "You died." -foregroundcolor red
}
else {
	write-host "YOU LIVE!...for now" -foregroundcolor green
}

$global:life = 0

gdr |
foreach {
	#selecting the drive(s) w/ 0gb space
	if ($_.free -lt 1) {
		write-host $_.name 'has' ($_.free/1024/1024/1024) 'gb remaining' -foregroundcolor magenta
		}
		
	#selecting the drive(s) w/ space
	else {
		write-host $_.name 'has' ($_.free/1024/1024/1024) 'gb remaining' -foregroundcolor green
		}
	}

	[console]::beep(3000,500)
	[console]::beep(1000,400)

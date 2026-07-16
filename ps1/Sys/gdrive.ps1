get-driveinfo {
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

		#little TTS beep when scan is finished
		if ($IsWindows -eq $True) {
		[console]::beep(3000,500)
		[console]::beep(1000,400)
		}
}

get-driveinfo

<#
.SYNOPSIS
    PowerShell weather utilizing wttr.in
.DESCRIPTION
    Check weather in ceratin location utilizing wttr.in 
.PARAMETER loc
    Location/City you would like to check
.EXAMPLE
    .\weather.ps1 -loc Austin
    .\weather.ps1 -loc 'San Francisco'
#>

param(
    [parameter(Mandatory=$true)]
    [string]$loc
)

$part1 = 'http://wttr.in/'
$part2 = '?format=3'

#OS check, Unix does not like the useragent flag
if ($IsWindows) {
   (curl ($part1 + $loc + $part2) -useragent 'curl').content

    $asdf = (curl ($part1 + $loc + $part2) -useragent 'curl').content

    add-type -assemblyname system.speech
    $speak = new-object system.speech.synthesis.speechsynthesizer

    $speak.speak($asdf) 
}

else {
    curl ($part1 + $loc + $part2)
}

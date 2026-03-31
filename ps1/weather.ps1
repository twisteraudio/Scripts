#get user input and put it into the url for wttr.in

param(
    [parameter(Mandatory=$true)]
    [string]$loc
)

#$weather = read-host 'Please type the city you wish to check'
$part1 = 'http://wttr.in/'
$part2 = '?format=3'

(curl ($part1 + $loc + $part2) -useragent 'curl').content

$asdf = (curl ($part1 + $loc + $part2) -useragent 'curl').content

add-type -assemblyname system.speech
$speak = new-object system.speech.synthesis.speechsynthesizer

$speak.speak($asdf)

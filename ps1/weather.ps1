#get user input and put it into the url for wttr.in

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

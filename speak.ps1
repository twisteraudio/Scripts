#make a text to speech synth
$text = read-host 'input text'
$weather = (curl http://wttr.in/dallas?format=3 -useragent 'curl').content

add-type -assemblyname system.speech
$speak = new-object system.speech.synthesis.speechsynthesizer
if($text -eq 'blarg') {
    $speak.speak('honk')
}
elseif ($text -eq 'weather') {
    $speak.speak($weather)
}
else{
    $speak.speak($text)
}

#$speak.speak($text)
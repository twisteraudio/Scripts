$range = 1..254

$range | foreach {
    $address = "192.168.1.$_"
    write-progress 'Scanning network...' $address -percentcomplete (($_/$range.count)*100)
    new-object PSObject -property @{
        Address = $address
        ping = test-connection $address -quiet -count 2
    }
}

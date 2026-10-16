<#
.SYNOPSIS
    Testing using the FlipperZero BadUSB to send an email with an attachment
.DESCRIPTION
    Searches for a test image an places it in Downloads folder
    Image will then be searchable in gmail
#>

param(
    [switch]$start,
    [switch]$clean
)

$asdf = get-childitem -path "$HOME" -recurse -filter "testing.*" -file -erroraction SilentlyContinue
$File = ($asdf).Name
$Directory = ($asdf).DirectoryName
$NewFile = get-childitem -path "$HOME/Downloads" -recurse -filter "testing.*" -file -erroraction SilentlyContinue

if ($start) {
    if (-not (test-path "$HOME/Downloads/testing.jpg")) {
        copy-item -path "$Directory/$File" -destination "$HOME/Downloads" -ErrorAction SilentlyContinue
    }
    elseif ($TestPath -eq $True) {
        continue
    }
}

if ($clean) {
    remove-item -path "$NewFile" -force
}

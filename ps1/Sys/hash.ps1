<#
.SYNOPSIS 
    File hash check
.DESCRIPTION
    Inspect each file in a directory and verify hashes
.PARAMETER t (target)
    Directory that is to be inspected
.PARAMETER h (hash)
    Location of hash file
.PARAMETER r
    Enables recursive search
.EXAMPLE
    .\hash.ps1 -t $home/TARGETDIRECTORYPATH -h $home/PATHTOHASHDIRECTORY
.EXAMPLE 
    .\hash.ps1 -t $home/TARGETDIRECTORYPATH -h $home/PATHTOHASHDIRECTORY -r
#>

param(

    [parameter(Mandatory=$true)]
    [string]$t,

    [parameter(Mandatory=$true)]
    [string]$h,

    [switch]$r
)

if (-not (Test-Path $t -PathType Container)) {
    Write-Error "Target directory does not exist: $t" -ErrorAction Stop
}

Function get-dirhash {
    Get-ChildItem -Path $t -File -Recurse:$r | 
            Get-FileHash -Algorithm SHA256 | 
            Select-Object @{
                Name="File";
                Expression={
                     [System.IO.Path]::GetRelativePath($t, $_.Path)
                }
            },
            @{
            Name = 'Hash'
            Expression = { $_.Hash }
            }
}

Function get-hashfile {
    $dirhash = get-dirhash

    if (-not (test-path $h)) {
        write-host "Hash file does now exist, creating new file..." -ForegroundColor Cyan
        $dirhash | Export-csv $h -NoTypeInformation
        write-host "Hash snapshot created" -ForegroundColor Green
        return
    }
}

Function get-comparison {
    $Current_Hash = get-dirhash

    $Hash_CSV = import-csv -path $h

    $compare = Compare-Object -ReferenceObject $Hash_CSV -DifferenceObject $Current_Hash -IncludeEqual -Property File, Hash

    if (-not $compare) {
        write-host "No Files selected for comparison" -ForegroundColor Yellow

    }

    foreach ($item in $compare) {
        $color = switch ($item.SideIndicator) {
            '==' { 'Green' }
            '=>' { 'Red' }
            '<=' { 'Magenta' }
            default { 'White' }
        }

        $file   = $item.File
        $hash   = $item.Hash
        $status = $item.SideIndicator
        
        Write-Host ("{0,-50} {1,-60} {2}" -f $file, $hash, $status) -ForegroundColor $color
    }

}

get-hashfile
get-comparison

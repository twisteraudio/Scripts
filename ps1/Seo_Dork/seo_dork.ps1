<#
.SYNOPSIS
    Search job postings using Google dorks
.DESCRIPTION
    Opens Firefox and searches for job postings utilizing Google dorks
.PARAMETER min
    How many days in the past to search for
.PARAMETER s
    Custom search string if searching for positions not listed in docs
.PARAMETER q
    Quick search
.PARAMETER basic
    Uses basic.txt to search
.PARAMETER sec
    Uses sec.txt to search
.EXAMPLE
    .\seo_dork.ps1 -s 'Systems Engineer' -min 7
    .\seo_dork.ps1 -q -min 14
    .\seo_dork.ps1 -basic -min 5
    .\seo_dork.ps1 -sec -min 2
    .\seo_dork.ps1 -min 1           <-will throw error since no -s but will still work
#>
#must be used as non-sudo

param(
    [parameter(Mandatory=$true)]
    [int]$min,
    [string]$s,
    [switch]$q,
    [switch]$basic,
    [switch]$sec
)

#get-date -format "yyyy-MM-dd"
#$DateNow = get-date -format "yyyy-MM-dd"

#getting date from yesterday, filtering results from input parameter
$Date_min1 = (get-date).AddDays(-$min).ToString("yyyy-MM-dd")

function Get-CleanContent {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        throw "File not found: $Path"
    }
    (Get-Content $Path | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }) -join ' '
}

function Get-SiteQuery {
    $sites     = Get-CleanContent "sites.txt"
    $location  = Get-CleanContent "location.txt"

    if ($s) {
        $positions = $s
    }
    elseif ($basic) {
        $positions = Get-CleanContent "basic.txt"
    }
    elseif ($sec) {
        $positions = Get-CleanContent "sec.txt"
    }
    else {
        $positions = ""
        Write-Warning "No position keywords provided (-s, -basic or -sec)"
    }

    if ($q) {
        $search = "(inurl:('careers' OR 'jobs' OR 'openings'))"
    }
    else {
        $search = $sites
    }

    $query = "$search $positions $location after:$Date_min1".Trim()

    Write-Host "Query being sent: $query" -ForegroundColor Cyan

    return $query
}

try {
    $search = Get-SiteQuery
    firefox --search $search
}
catch {
    Write-Error "Error: $($_.Exception.Message)"
}
finally {
    Write-Host "Complete" -ForegroundColor Green
}

#goal: use google dorks to give results of job postings within input parameter
#must be used as non-sudo

param(
    [parameter(Mandatory=$true)]
    [string]$min,
    [switch]$q
)

#getting date from yesterday, filtering results from input parameter
$Date_min1 = (get-date).AddDays(-$min) | get-date -format "yyyy-MM-dd"

#What sites the search will use
$sites = '(
site:greenhouse.io OR 
site:lever.co OR 
site:jobs.ashbyhq.com OR 
site:myworkdayjobs.com OR 
site:icims.com OR 
site:taleo.net OR 
site:smartrecruiters.com OR
site:bamboohr.com
) '

#Position Keywords
$positions = '(
"cybersecurity" OR 
"cyber security" OR 
"information security" OR 
"infosec" OR 
"SOC" OR 
"CISO" OR 
"pentest" OR 
"security engineer" OR
"systems administrator"
)'

#Location Keywords
$location = '(
"dallas" OR
"dfw" OR
"dallas/ft worth"
"plano" OR
"allen" OR
"mckinney" OR
"irving" OR
"frisco" OR
"rockwall" OR
"rowlett" OR
"las colinas" OR
"addison" OR
"richardson"
)'

if ($q) {
    $search = "(inurl:'careers' OR 'jobs')"
}
else {
    $search = $sites
}

firefox --search "$search $positions AND $location after:$Date_min1"

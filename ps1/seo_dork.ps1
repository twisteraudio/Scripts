#goal: use google dorks to give results of applications within 3 days
#must be used as non-sudo

#get-date -format "yyyy-MM-dd"
$DateNow = get-date -format "yyyy-MM-dd"

#getting date from yesterday, filtering results from ~24hours
$Date_min1 = (get-date).AddDays(-1) | get-date -format "yyyy-MM-dd"

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
$location = '("tx" OR
"dallas" OR
"plano" OR
"dfw" OR
"allen" OR
"mckinney" OR
"irving" OR
"frisco" OR
"rockwall" OR
"rowlett" OR
"las colinas" OR
"addison"
)'

firefox --search "$sites $positions AND $location after:$Date_min1"
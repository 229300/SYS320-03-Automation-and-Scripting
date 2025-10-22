# Challenge 1: Write a Powershell function that obtains IOC from the given web page
<#
function getIOC(){

$page = Invoke-WebRequest -TimeoutSec 2 http://localhost/ioc.html

# get all tr elements
$trs=$page.ParsedHTML.body.getElementsByTagName("tr")

# array to hold results
$FullTable = @()
for($i=1; $i -lt $trs.length; $i++){

    # get every td element of current tr element
       $tds= $trs[$i].getElementsByTagName("td")

       # want to seperate start time and end time from one time field
       # $Times = $tds[5].innerText.split("-")
       
           $FullTable += [pscustomobject]@{"Pattern" = $tds[0].innerText; `
                                       "Explanation" = $tds[1].innerText; `
                                        }
    }# for loop end
   
    return $FullTable
}

#>

<#
function ApacheLogs() {
$logsNotformatted = Get-Content c:\xampp\apache\logs\midterm-access.log
$tableRecords = @()

for($i=0; $i -lt $logsNotformatted.Count; $i++){

# split a string into words
$words = $logsNotformatted[$i].split(" ");

$tableRecords += [pscustomobject]@{ "IP" = $words[0];
                                   "Time" = $words[3].Trim('[');
                                   "Method" = $words[5].Trim('"');
                                   "Page" = $words[6];
                                   "Protocol" = $words[7];
                                   "Response" = $words[8];
                                   "Referrer" = $words[10];
                                   } 

} # end of for loop
return $tableRecords | Where-Object { $_.IP -ilike "10.*" }
}
$tableRecords = ApacheLogs
$tableRecords | Format-Table -AutoSize -Wrap

#>

function ApacheLogs {
    param (
        [string]$LogPath = "C:\xampp\apache\logs\midterm-access.log"
    )

    # Get IOCs (patterns)
    $iocList = getIOC
    $Indicators = $iocList.Pattern

    $logsNotformatted = Get-Content $LogPath
    $tableRecords = @()

    for ($i = 0; $i -lt $logsNotformatted.Count; $i++) {
        $words = $logsNotformatted[$i].Split(" ")

        $tableRecords += [pscustomobject]@{
            "IP"        = $words[0]
            "Time"      = $words[3].Trim('[')
            "Method"    = $words[5].Trim('"')
            "Page"      = $words[6]
            "Protocol"  = $words[7]
            "Response"  = $words[8]
            "Referrer"  = $words[10]
        }
    }

    # Filter by Indicators from ioc.html
    $filteredRecords = $tableRecords | Where-Object {
        $match = $false
        foreach ($indicator in $Indicators) {
            if ($_.Page -match [regex]::Escape($indicator)) {
                $match = $true
                break
            }
        }
        $match
    }

    return $filteredRecords
}


$tableRecords = ApacheLogs
$tableRecords | Format-Table -AutoSize -Wrap

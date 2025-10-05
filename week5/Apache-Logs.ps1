
#cd C:\xampp\apache\logs\
#Get-Content C:\xampp\apache\logs\access.log
#Get-Content C:\xampp\apache\logs\access.log -Tail 5
#Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 ',' 400 '
#Get-Content C:\xampp\apache\logs\access.log | Select-String ' 200 ' -NotMatch


<#
$A = Get-Childitem C:\xampp\apache\logs\*.log | Select-String -AllMatches 'error'
$A[-5..-1]
#>


<#
$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '

$regex = [regex] "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}"

$ipsUnorganized = $regex.Matches($notfounds)

$ips = @()
for($i=0; $i -lt $ipsUnorganized.Count; $i++){
 $ips += [pscustomobject]@{ "IP" = $ipsUnorganized[$i].Value; }
 }
 $ips | Where-Object { $_.IP -ilike "10.*" }
 #>



 <#
 $ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*" }
 $counts = $ipsoftens | Group IP
 $counts | Select-Object Count, Name
 #>



function ApacheLogs1() {
$logsNotformatted = Get-Content c:\xampp\apache\logs\access.log
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
                                   "Client" = $words[11..($words.Length-1)]; } 

} # end of for loop
return $tableRecords | Where-Object { $_.IP -ilike "10.*" }
}
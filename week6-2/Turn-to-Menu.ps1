. (Join-Path $PSScriptRoot String-Helper.ps1)
#. (Join-Path $PSScriptRoot Management1.ps1)

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Last 10 Apache logs: `n"
$Prompt += "2 - Last 10 fail logins`n"
$Prompt += "3 - At risk Users`n"
$Prompt += "4 - Start chrome`n"
$Prompt += "5 - exit`n"


$operation = $true


while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host

    if($choice -eq 5){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $last10 = last10
        Write-Host ($last10 | Out-String)

}

    elseif($choice -eq 2){
        $fail10 = getFailedLogins 3650 | Sort-Object Time -Descending | select-Object -First 10
        Write-Host ($fail10 | Out-String)

}

    elseif($choice -eq 3){                                   
        $days = Read-Host -Prompt "Enter number of days"      
        $failed = getFailedLogins $days                      
        $atRisk = $failed | Group-Object User | Where-Object { $_.Count -gt 10 } |  
                  Select-Object @{n='User';e={$_.Name}}, @{n='FailedCount';e={$_.Count}} 
        if ($atRisk) {                                        
            Write-Host ($atRisk | Format-Table | Out-String)  
        } else {                                             
            Write-Host "No at-risk users found."             
        }                                                     
    }                 
     elseif($choice -eq 4){
        chrome 
        
}
}


function  last10{
Get-Content C:\xampp\apache\logs\access.log -tail 10
}


function getFailedLogins($timeBack){
  
  $failedlogins = Get-EventLog security -After (Get-Date).AddDays("-"+"$timeBack") | Where { $_.InstanceID -eq "4625" }

  $failedloginsTable = @()
  for($i=0; $i -lt $failedlogins.Count; $i++){

    $account=""
    $domain="" 

    $usrlines = getMatchingLines $failedlogins[$i].Message "*Account Name*"
    $usr = $usrlines[1].Split(":")[1].trim()

    $dmnlines = getMatchingLines $failedlogins[$i].Message "*Account Domain*"
    $dmn = $dmnlines[1].Split(":")[1].trim()

    $user = $dmn+"\"+$usr;

    $failedloginsTable += [pscustomobject]@{"Time" = $failedlogins[$i].TimeGenerated; `
                                       "Id" = $failedlogins[$i].InstanceId; `
                                    "Event" = "Failed"; `
                                     "User" = $user;
                                     }

    }
    return $failedloginsTable
} # End of function getFailedLogins

function chrome{
if (-not (Get-Process chrome -ErrorAction SilentlyContinue)) { Start-Process "chrome.exe" "https://www.champlain.edu" } else { Stop-Process -Name chrome -Force }
}
chrome

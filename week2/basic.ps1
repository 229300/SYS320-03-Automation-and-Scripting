(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -ilike "Ethernet" }).IPAddress

(Get-NetIPAddress -AddressFamily IPv4 | Where-Object{$_.InterfaceAlias -ilike "Ethernet" }).PrefixLength

Get-WmiObject -list | Where-Object { $_.Name -ilike "Win32_net*" } | Sort-Object

Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$True" | select DHCPServer | Format-Table -Hidetableheaders

(Get-Dnsclientserveraddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ilike "Ethernet" }).ServerAddresses[0]

cd $PSScriptRoot 
$files=(Get-ChildItem) 

for ($j=0; $j -le $files.length; $j++ ){

if ($files[$j].name -ilike "*ps1") {

    write-host $files[$j].name 

}

}

$folderpath="PSScriptRoot\outfolder"
if (Test-Path $folderpath){
    Write-Host "Folder Already Exists"
    }
    else{
        New-Item -ItemType Directory -Path $folderpath | Out-Null
    }

cd $PSScriptRoot
$files = Get-ChildItem

$folderPath = "PSScriptRoot/outfolder/"
$filePath = $folderPath + "out.csv"

$files | Where-Object { $_.Extension -eq ".ps1" } | `
Export-Csv -Path $filePath

$files = Get-ChildItem -Recurse -File
$files | Rename-Item -NewName { $_.Name.Replace('.csv', '.log') }
Get-ChildItem -Recurse -File

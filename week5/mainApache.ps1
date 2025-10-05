.(Join-Path $PSScriptRoot 'Apache-Logs.ps1')

$pagevisited = Read-Host "What Page are we searching for?"
$httpcode = Read-Host "What HTTP code are we searching for?"
$browserused = Read-Host "What browser are we searching for?"

$apachelogsfiltered = ApacheLogs1 "sdf" "404" "500" "Chrome"
$apachelogsfiltered

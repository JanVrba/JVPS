# RunJenkinsBuild.ps1
# Purpose :  Script Run Jenkins Job
# Date : 28/07/2016

[CmdletBinding()]
param()
$jobBuildRunUri = "http://jenkins/job/jobname/buildWithParameters?clientFolder="

$uri = $jobBuildRunUri
$user = $user
$pass = $apiToken
$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }

Write-Information "[RunJenkinsBuild.ps1] Starting Jenkins Job Build with parameter clientFolder $firmname "

Invoke-RestMethod -Uri $uri -Method Post  -Headers $headers

Write-Information "[RunJenkinsBuild.ps1] Jenkins Build started. Result can be checked here : `n $jobLastBuildUri"
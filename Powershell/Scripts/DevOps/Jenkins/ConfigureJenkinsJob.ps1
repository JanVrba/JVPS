# ConfigureJenkinsJob.ps1
# Purpose :  Script Configure Jenkins Job - add Firmname to choise of ClientFolder
# Date : 28/07/2016

[CmdletBinding()]
param()

$jobConfigUri = "http://jenkins/job/jobname/config.xml"

Write-Information "[ConfigureJenkinsJob.ps1] Starting ..."

$uri = $jobConfigUri
$user = $user
$pass = $apiToken
$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }

Write-Information "[ConfigureJenkinsJob.ps1] Changing Config.xml ..."

(Invoke-WebRequest -Uri $uri -Headers $headers).Content > C:\Temp\ConfigJenkins.xml 
[xml]$configXmlLocal = (Get-Content C:\Temp\ConfigJenkins.xml)

$xpath1 = $configXmlLocal.project.properties.'hudson.model.ParametersDefinitionProperty'.parameterDefinitions
$xpathClientFolders = $xpath1.'hudson.model.ChoiceParameterDefinition'.choices.a
$newNode = $xpathClientFolders.ChildNodes[1].Clone()
$newNode.'#text' = $firmname 
$xpathClientFolders.AppendChild($newNode) | Out-Null
$configXmlLocal.Save("C:\Temp\Config.xml")

[xml]$newConfig = get-content("C:\Temp\Config.xml")

Write-Information "[ConfigureJenkinsJob.ps1] Updating Config.xml ..."

Invoke-RestMethod -Uri $uri -Method Post  -Headers $headers -Body $newconfig

If ((Invoke-WebRequest -Uri $uri -Headers $headers).StatusCode -eq 200) {
	Write-Information "[ConfigureJenkinsJob.ps1] New Folder $firmName added to Jenkins Job Configuration."
}

Remove-Item -Path "C:\Temp\ConfigJenkins.xml" -Force
Remove-Item -Path "C:\Temp\Config.xml" -Force
# Name : Get-FromOctopus
# Date : 08/07/2016
# Purpose : Function using REST API method GET from Octopus Deploy
# REST API GITHUB : https://github.com/OctopusDeploy/OctopusDeploy-Api
# Inspired by : https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/REST/PowerShell/Projects/DeleteProjectsWithoutDeploymentProcess.ps1

Function Get-FromOctopus{
[CmdletBinding()]
Param(
    [Parameter()]
    [string]$OctopusUrl = "http://localhost",

    [Parameter()]
    [string]$relUrl,

    [Parameter()]
    [string]$ApiKey = ""
    )

$uri = "$OctopusUrl" + "/$relUrl" + "`?apiKey=$ApiKey"
  try {
    return Invoke-RestMethod -Uri $uri -Method Get
  } # close try
  catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 404) {
      return $null
    } else {
      throw $_.Exception
    } # close if
  } # close catch
} # close function 
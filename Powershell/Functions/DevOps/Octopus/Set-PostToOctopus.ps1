# Name : Set-PostToOctopus
# Date : 11/07/2016
# Purpose : Function using REST API method POST to Octopus Deploy
# REST API GITHUB : https://github.com/OctopusDeploy/OctopusDeploy-Api
# Inspired by : https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/REST/PowerShell/Projects/DeleteProjectsWithoutDeploymentProcess.ps1

Function Set-PostToOctopus{
[CmdletBinding()]
Param(
    [Parameter(Position=0)]
    [string]$relUrl,

    [Parameter()]
    [string]$OctopusUrl = "http://localhost",

    [Parameter()]
    [string]$ApiKey = "API-AID7PBIMNNQ7D0XM89Z78ZZ1ZXU"
    )

$uri = "$OctopusUrl" + "/$relUrl" + "`?apiKey=$ApiKey"
  try {
    return Invoke-RestMethod -Uri $uri -Method Post
  } # close try
  catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 404) {
      return $null
    } else {
      throw $_.Exception
    } # close if
  } # close catch
} # close function 
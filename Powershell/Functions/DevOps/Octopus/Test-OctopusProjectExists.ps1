# Name : Test-OctopusProjectExists.ps1
# Date : 12/07/2016
# Purpose : Function using RESTAPI and Method GET of to test if Octopus project already exists
Function Test-OctopusProjectExists{

[CmdletBinding()]

Param(  

    [Parameter()]
    [string]$OctopusUrl,

    [Parameter()]
    [string]$ApiKey,

	 [Parameter()]
    [string]$projectSlug
    )

$uri = "$OctopusUrl" + "/api/projects" + "/$projectSlug" + "`?apiKey=$ApiKey"

Try { 
    Invoke-RestMethod -Uri $uri -Method Get | out-null 
    return $true
} # close Try
Catch { 
    return $false 
} # close Catch
    
} # close function 
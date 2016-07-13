# Name : Edit-OctopusProjectVariable.ps1
# Date : 13/07/2016
# Purpose : Function change value of Octopus project varible using Octopus Client .NET
# Inspired by : https://github.com/OctopusDeploy/OctopusDeploy-Api/blob/master/Octopus.Client/PowerShell/Variables/UpdateVariableInProject.ps1

Function Edit-OctopusProjectVariable{
[CmdletBinding()]
Param(
    [Parameter()]
    [string]$octopusURL,
     
    [Parameter()]
    [string]$octopusAPIKey,

    [Parameter()]
    [string]$projectName,

    [Parameter(ParameterSetName=’varName’)]
    [string]$varName,

    [Parameter(ParameterSetName=’varID’)]
    [string]$varID,
  
    [Parameter()]
    [string]$newValue

    )


# if is called  from Octopus server

Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll" 

<#  or if from Tentacle
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Octopus.Client.dll"
 #>

$endpoint = new-object Octopus.Client.OctopusServerEndpoint ($octopusURL, $octopusAPIKey)
$octoRepo = new-object Octopus.Client.OctopusRepository $endpoint

#Get Project
$project = $octoRepo.Projects.FindByName($projectName)

#Get Project's variable set
$variableSet = $octoRepo.VariableSets.Get($project.links.variables)

#Get variable to update 
Switch($PSCmdlet.ParameterSetName){
    "varName" { 
        $variable = $variableSet.Variables | Where-Object {$_.name -eq $varName}
     } # close switch varName

     "varID" {
        $variable = $variableSet.Variables | Where-Object {$_.Id -eq $varID}
     } # close switch varID
} # close switch

#Update variable
$variable.Value = $newValue
$Variable.IsSensitive = $false #Set to $true if you want to treat this variable as sensitive 

#Save variable set
$octoRepo.VariableSets.Modify($variableSet) | out-null

Write-Information "$($variable.Name):Value = $($variable.Value) "

} # close function
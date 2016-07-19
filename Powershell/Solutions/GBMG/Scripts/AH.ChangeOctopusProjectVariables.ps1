# ChangeOctopusProjectVariables.ps1
# Date : 12/07/2016
# Purpose : Script change variables at new Octopus project using Octopus.Client .NET library

[CmdletBinding()]
param(
		[Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$firmName
) # close param

# ---------------------------------------------
# Variables used from AH.Environment.[Env] data
# 
# $OctopusAPIKey
# $OctopusURL
# $testEnvironmentID 
# $prodEnvironmentID
# $connStringTest
# $connStringProd
#
# ---------------------------------------------
# ---------------------------------------------
# Functions used from AHModule
# 
# New-OctopusMachineKey
# Edit-OctopusProjectVariable
#


# if is called  from Octopus server

Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Octopus\Octopus.Client.dll" 


<#  or if from Tentacle
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Newtonsoft.Json.dll"
Add-Type -Path "C:\Program Files\Octopus Deploy\Tentacle\Octopus.Client.dll"
 #>

$endpoint = new-object Octopus.Client.OctopusServerEndpoint ($octopusURL, $octopusAPIKey)
$octoRepo = new-object Octopus.Client.OctopusRepository $endpoint
$newProject = $firmName + " AllHires Graduate Deploy"

$project = $octoRepo.Projects.FindByName($newProject)

$variableSet = ($octoRepo.VariableSets.Get($project.links.variables)).Variables

$params = @{
    octopusURL = $OctopusURL
    octopusAPIKey = $OctopusAPIKey
    projectName = $newProject
}


Write-Information "[ChangeOctopusProjectVariables.ps1] Starting ..."

ForEach ($variable in $variableSet) {	
    
    $variableValue = $variable.Value
    $variableScope = ($variable.Scope).Values
    $variableName = $variable.Name
    $variableID = $variable.Id   


    # change values for AllHires TEST

    If ($variableScope -like $testEnvironmentID) {
        
        # change connectionstring for AllHires TEST

        If ($variableName -like "ConnectionString") {
        
            $paramsConnString = $params + @{
                varID = $variableID
                newValue = $connStringTest

            } # close paramsConnString

		Write-Information "[if ConnectionStringTest] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsConnString

        } # close if ConnectionStringTest

        If ($variableName -like "MachineKeyDecryptionKey") {
            $decryptionKey = New-OctopusMachineKey -algorithm "AES"
            $paramsKey = $params + @{
                varID = $variableID
                newValue = $decryptionKey

            } # close paramsKey
			
		Write-Information "[if MachineDecryptionKey] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsKey

        } # close if MachineDecryptionKey

        If ($variableName -like "MachineKeyValidationKey") {
            $validationKey = New-OctopusMachineKey -algorithm "AES"
            $paramsKey = $params + @{
                varID = $variableID
                newValue = $validationKey

            } # close paramsKey

		Write-Information "[if MachineValidationKey] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsKey

        } # close if MachineValidationKey

     } # close if testEnvironment

     # change values for AllHires Prod

     If ($variableScope -like $prodEnvironmentID) {

        # change connectionstring for AllHires Prod

        If ($variableName -like "ConnectionString") {
            $paramsConnString = $params + @{
                varID = $variableID
                newValue = $connStringProd
            } # close paramsConnString

		Write-Information "[if ConnectionStringProd] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsConnString

        } # close if ConnectionStringProd

        If ($variableName -like "MachineKeyDecryptionKey") {
            $decryptionKey = New-OctopusMachineKey -algorithm "AES"
            $paramsKey = $params + @{
                varID = $variableID
                newValue = $decryptionKey

            } # close paramsKey

		Write-Information "[if MachineDecryptionKey] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsKey

        } # close if MachineDecryptionKey

        If ($variableName -like "MachineKeyValidationKey") {
            $validationKey = New-OctopusMachineKey -algorithm "AES"
            $paramsKey = $params + @{
                varID = $variableID
                newValue = $validationKey

            } # close paramsKey

		Write-Information "[if MachineValidationKey] $variableName, $variableScope ..."

        Edit-OctopusProjectVariable @paramsKey

        } # close if MachineValidationKey

     } # close if ProdEnvironment
     
} # close ForEach

$variableSet = ($octoRepo.VariableSets.Get($project.links.variables)).Variables

ForEach ($variable in $variableSet) {	
    
    $variableValue = $variable.Value
    $variableScope = ($variable.Scope).Values
    $variableName = $variable.Name
   
    # change all remaining values contains COV to new firm name

    If ($variableValue -like "*cov*") {

        $newValue = $variableValue -replace "cov" , $firmName
        $paramsFirmName = $params + @{
                varID = $variableID
                newValue = $newValue
        } # close paramsFirmname

		Write-Information "[if Firmname] $variableName, $variableScope setting $newValue..."

        Edit-OctopusProjectVariable @paramsFirmname

    } # close if Firmname

} # close ForEach

Write-Information "[ChangeOctopusProjectVariables.ps1] Variables for project $newProject changed."
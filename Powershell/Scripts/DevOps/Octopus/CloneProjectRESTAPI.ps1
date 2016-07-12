# CloneOctopusProject.ps1
# Date : 12/07/2016
# Purpose : Script clone Octopus Project using REST API and method POST

[CmdletBinding()]
param(
		[Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$OctopusURL ,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()] 
		[String]
		$OctopusAPIKey

) # close param

$header = @{ "X-Octopus-ApiKey" = $OctopusAPIKey }



Write-Information "[CloneOctopusProject.ps1] Starting ..."
If (-not(Test-OctopusProjectExists -OctopusUrl $OctopusURL -ApiKey $OctopusAPIKey -projectSlug )) {

	$body = @'
	{
		"Id": "*",
		"VariableSetId": "variableset-PROJECTID",
		"DeploymentProcessId": "deploymentprocess-PROJECTID",
		"Description": "",
		"IncludedLibraryVariableSetIds":[],
		"IsDisabled": false,
		"Name": "COV ALLHIRES GRADUATE DEPLOY",
		"Slug": "COV ALLHIRES GRADUATE DEPLOY",  
		"DefaultToSkipIfAlreadyInstalled": false,
		"ProjectGroupId": "PROJECTGROUP",
		"LifecycleId": "LIFECYCLE"
	}
'@

	$newBody = $body -creplace "PROJECTID" , $projectTemplateID
	$newBody = $newBody -creplace "COV", $firmName
	$newBody = $newBody -creplace "PROJECTGROUP", $projectGroupID
	$newBody = $newBody -creplace "LIFECYCLE", $lifecycleID

	$uri = "$OctopusURL/api/projects?clone=" + $ProjectTemplateID
	Write-Information "[CloneOctopusProject.ps1] Cloning Octopus Project with new name $newProjectSlug ..."
	Invoke-RestMethod $uri -Method Post -Headers $header -Body $newbody | Out-Null
	If (Test-OctopusProjectExists -OctopusUrl $OctopusURL -ApiKey $OctopusAPIKey -projectSlug $newProjectSlug) {
		Write-Information "[CloneOctopusProject.ps1] Octopus Project $newProjectSlug created."
	} # clone project
} else {
	Write-Warning "Octopus Project $newProjectSlug already exists!"
}
# Name : CloneProjectRESTAPI.ps1
# Date : 12/07/2016
# Purpose : Clone Octopus Project using REST API and method POST

$OctopusAPIKey = "API-BCNTWSJC2EQ3ULGXET6QPBGUC" 
$OctopusURL = "http://localhost" 

$header = @{ "X-Octopus-ApiKey" = $OctopusAPIKey }

$body = @'
{
"Id": "*",
"VariableSetId": "variableset-Projects-61",
"DeploymentProcessId": "deploymentprocess-Projects-61",
"Description": "",
"IncludedLibraryVariableSetIds": [],
"IsDisabled": false,
"Name": "Apply4Law_Clone2",
"Slug": "Apply4Law_Clone2",  
"DefaultToSkipIfAlreadyInstalled": false,
"ProjectGroupId": "ProjectGroups-1",
"LifecycleId": "Lifecycles-21"
}
'@

Invoke-RestMethod $OctopusURL/api/projects?clone=Projects-61 -Method Post -Headers $header -Body $body
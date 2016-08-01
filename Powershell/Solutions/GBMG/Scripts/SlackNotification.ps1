function Slack-Rich-Notification ($notification)
{
    $payload = @{
        channel = $OctopusParameters['Channel']
        username = $OctopusParameters['Username'];
        icon_url = $OctopusParameters['IconUrl'];
        attachments = @(
            @{
            fallback = $notification[\"fallback\"];
            color = $notification[\"color\"];
            fields = @(
                @{
                title = $notification[\"title\"];
                value = $notification[\"value\"];
                });
            };
        );
    }

    Invoke-RestMethod -Method POST -Body ($payload | ConvertTo-Json -Depth 4) -Uri $OctopusParameters['HookUrl']  -ContentType 'application/json'
}

$IncludeMachineName = [boolean]::Parse($OctopusParameters['IncludeMachineName']);
if ($IncludeMachineName) {
    $MachineName = $OctopusParameters['Octopus.Machine.Name'];
    $FormattedMachineName = \"($MachineName)\";
}

if ($OctopusParameters['Octopus.Deployment.Error'] -eq $null){
    Slack-Rich-Notification @{
        title = \"Success\";
        value = \"Deploy $OctopusProjectName release $OctopusReleaseNumber to $OctopusEnvironmentName $FormattedMachineName\";
        fallback = \"Deployed $OctopusProjectName release $OctopusReleaseNumber to $OctopusEnvironmentName successfully\";
        color = \"good\";
    };
} else {
    Slack-Rich-Notification @{
        title = \"Failed\";
        value = \"Deploy $OctopusProjectName release $OctopusReleaseNumber to $OctopusEnvironmentName $FormattedMachineName\";
        fallback = \"Failed to deploy $OctopusProjectName release $OctopusReleaseNumber to $OctopusEnvironmentName\";
        color = \"danger\";
    };
}"
 
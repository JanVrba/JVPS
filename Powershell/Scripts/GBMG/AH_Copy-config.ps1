# CopyConfig.ps1
# Date : 16/06/2016
# Purpose : Script perform copy of IIS shared configuration

[CmdletBinding(SupportsShouldProcess=$True)]
param()

# Functions used from Module AHModule.psm1
#
# Get-NlbNodeStatusCode
# Get-NlbConvergedNodesCount
#
# ---------------------------------------------
# Variables used from AH.Environment.[Env] data
# 
# $ManagementHost
# $NlbInterface
# $webservers
# $NlbClusterIP
#
# ---------------------------------------------


Write-Information "[CopyConfig.ps1] Starting ..."

# Confirm script is run from the management host

if ($env:COMPUTERNAME -eq $ManagementHost ) {

} else {
    
    write-warning "This script should be run from the $ManagementHost server, exiting ...!"
    start-sleep -s 5 
    break

} # close if

Foreach ($server in $webservers) {

    Write-Verbose "Checking NLB status at $server ..."

    $NlbNodeStatus = Get-NlbNodeStatusCode -ComputerName $server

    $clusterServerShutdown = $false   

    Switch ($NlbNodeStatus) {

        Default {

            Write-Verbose "Node $server status is $NlbNodeStatus ... Stopping NLB cluster node"

            Try {

                Stop-NlbClusterNode -Hostname $server -InterfaceName $NlbInterface -Timeout 30 | Out-Null
               
            } # close try

            Catch {

                $errormsg = "Error stopping host $server. $_.Exception.Message" 
                throw $errormsg
                break

            } # close Catch

            $clusterServerShutdown = $true

        } # close Default

        Converged {

            Write-Verbose "Node $server status is $NlbNodeStatus ..."

        } # close Converged

        Stopped {

            Write-Warning "Node $server status is $NlbNodeStatus ..."

        } # close Stopped

    } # close Switch     

    Write-Verbose "Copying config to $server ..."

    Copy-Item "c:\configuration\Shared\administration.config" "\\$server\configuration\Shared" -Force
    Copy-Item "c:\configuration\Shared\applicationHost.config" "\\$server\configuration\Shared" -Force

    Write-Verbose "Copying Certificates to $server"

    robocopy "c:\configuration\Certificates" "\\$server\configuration\Certificates" /mir | Out-Null 
    
    If ($clusterServerShutdown -eq $True) {

		Write-Verbose "Starting $server"

		try {

			Start-NlbClusterNode -HostName $server -InterfaceName $NlbInterface | Out-Null

        } # close try

		catch {

			$errormsg = "Error starting host $server. $_.Exception.Message"
			throw $errormsg
			break

        } # close catch

    } # close If

	Write-Verbose "Shared Configuration Copied to $server"

} # close foreach

Write-Verbose "Checking NLB state"

$NlbCheck = Get-NlbConvergedNodesCount -InterfaceName $NlbInterface -Hostname $NlbClusterIP

If (($NlbCheck) -lt 2) {

	Write-Warning "$NlbCheck Converged node ! At least two hosts must be active in NLB, please check!"

} Else { 
	
	Write-Verbose "NLB status OK. $NlbCheck nodes are at Converged state"

} # close Else



Write-Verbose "Preparing copy of configuration ..."

# --> Function for backup with current date and delete oldest file?
  
Remove-Item c:\configuration\backup\*.5

get-childItem c:\configuration\backup\*.config.4 | rename-item -newname { $_.name -replace '\.config.4','.config.5' }
get-childItem c:\configuration\backup\*.config.3 | rename-item -newname { $_.name -replace '\.config.3','.config.4' }
get-childItem c:\configuration\backup\*.config.2 | rename-item -newname { $_.name -replace '\.config.2','.config.3' }
get-childItem c:\configuration\backup\*.config.1 | rename-item -newname { $_.name -replace '\.config.1','.config.2' }

Copy-Item c:\configuration\shared\*.config c:\configuration\backup\
get-childItem c:\configuration\backup\*.config | rename-item -newname { $_.name -replace '\.config','.config.1' }


Copy-Item C:\Windows\System32\inetsrv\config\administration.config c:\configuration\Shared -Force
Copy-Item C:\Windows\System32\inetsrv\config\applicationHost.config c:\configuration\Shared -Force

Write-Verbose "Shared Configuration at server $ManagementHost is up to date. Done!"


# source : https://github.com/anpur/powershellget-module

# create Module manifest

 New-ModuleManifest [path] 

# Register local folder as Repository

 Register-PSRepository -Name Local_Nuget_Feed -SourceLocation C:\NuGetFeed -PublishLocation C:\NuGetFeed -InstallationPolicy Trusted

# Publish 

 Publish-Module -Path .\Module\[name of module] -Repository Local_Nuget_Feed -NuGetApiKey 'use real NuGetApiKey for real nuget server here'

 # Install

 Install-Module [name of module] -Repository Local_Nuget_Feed -Scope CurrentUser
# source : https://blogs.msdn.microsoft.com/mvpawardprogram/2014/10/06/package-management-for-powershell-modules-with-powershellget/

# Get a list of all registered PowerShellGet repositories

Get-PSRepository | Format-List *

# Register a PowerShellGet repository for use on the local system

# (note, this repository does not really exist; it’s just an example)

Register-PSRepository -Name Private –SourceLocation http://poshoholic.com

# Change a property on a PowerShellGet repository

Set-PSRepository –Name Private –InstallationPolicy Trusted

# Unregister a PowerShellGet repository

Unregister-PSRepository –Name Private

# Find all modules that are available in all PowerShellGet repositories

Find-Module –Name *

# Find a specific module that is available in a specific PowerShellGet repository

# (note, DebugPx is an actual module in the gallery)

Find-Module -Name DebugPx -Repository PSGallery | Format-List *

# Install a module, along with required modules, for all users

# (note, in the CTP, required modules must be explicitly installed)

# (also note, installing for all users requires elevation)

Install-Module -Name DebugPx,SnippetPx

# Update all modules that you installed using PowerShellGet

Update-Module

# Publish a module that you created to PowerShellGet

# (note, this is not a valid NuGet API key, and this assumes you have a

#  module called MyGreatModule with a module manifest in a discoverable

#  location)

$nugetApiKey = [System.Guid]::NewGuid().ToString()

Publish-Module -Name MyGreatModule -NuGetApiKey $nugetApiKey
 
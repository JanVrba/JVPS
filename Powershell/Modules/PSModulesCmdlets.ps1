# source : https://technet.microsoft.com/en-us/library/dd878324.aspx

#  This cmdlet creates a new dynamic module that exists only in memory. The module is created from a script block, 
#   and its exported members, such as its functions and variables, 
#   are immediately available in the session and remain available until the session is closed.

New-Module

# This cmdlet creates a new module manifest (.psd1) file, populates its values, 
#  and saves the manifest file to the specified path. 
#  This cmdlet can also be used to create a module manifest template that can be filled in manually.

New-ModuleManifest

# This cmdlet adds one or more modules to the current session.

Import-Module 

# disable verbose preference from Import-Module

Import-Module [name of Module ] -Verbose:$false

#  This cmdlet retrieves information about the modules that have been or that can be imported into the current session.

Get-Module 

# This cmdlet specifies the module members (such as cmdlets, functions, variables, and aliases) 
# that are exported from a script module (.psm1) file or from a dynamic module created by using the New-Module cmdlet.

Export-ModuleMember

# This cmdlet removes modules from the current session.

Remove-Module

 # This cmdlet verifies that a module manifest accurately describes the components of a module by verifying that the files 
 # that are listed in the module manifest file (.psd1) actually exist in the specified paths.

Test-ModuleManifest

# This variable contains the directory from which the script module is being executed. It enables scripts to use the module path to access other resources.

$PSScriptRoot

# This environment variable contains a list of the directories in which Windows PowerShell modules are stored. 
# Windows PowerShell uses the value of this variable when importing modules automatically and updating Help topics for modules.

$env:PSModulePath


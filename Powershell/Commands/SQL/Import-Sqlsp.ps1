# add modules path to PSModule Path

$env:PsModulepath=$env:PsModulepath +";" + "C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules"

# import-module

Import-Module "sqlps" -DisableNameChecking
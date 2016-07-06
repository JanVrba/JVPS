# Name : FindAndReplace.ps1
# Date : 06/07/2016
# Purpose : Script find and replace strings and inform about number of changes

$file = [path to file]
# replace method using Regex , for test check : https://regex101.com/

(get-content $file ) -creplace [old value], [new value] | set-content $file 

$NumberofChanges = ((Get-Content $file) | Select-String [new value] | measure).Count
if ($NumberofChanges -gt 0) {
	Write-Information  "[new value] changed at $NumberofChanges places!"
}
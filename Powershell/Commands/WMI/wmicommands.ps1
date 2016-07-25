# source : https://blogs.msdn.microsoft.com/koteshb/2010/02/12/powershell-how-to-find-details-of-operating-system/

#Name of the Operating System

(Get-WmiObject Win32_OperatingSystem).Name

# Is Operating System 32-bit or 64-bit

(Get-WmiObject Win32_OperatingSystem).OSArchitecture


# Name of the Machine

(Get-WmiObject Win32_OperatingSystem).CSName


# There are many more properties of the Operating System that are exposed. To obtain more details, run the following


Get-WmiObject Win32_OperatingSystem | Get-Member


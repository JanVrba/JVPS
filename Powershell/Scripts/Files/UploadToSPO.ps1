# Upload_csv_SPO.ps1
# Date : 06/08/2018
# Purpose : upload csv files to SharePoint Online

# sources 
# ---------------------------------------------------------------------------------------------------------------------
# https://www.c-sharpcorner.com/article/sharepoint-online-automation-o365-sharepoint-online-how-to-upload-your-files-r/
# https://stackoverflow.com/questions/38397084/trying-to-upload-files-to-subfolder-in-sharepoint-online-via-powershell
# https://social.technet.microsoft.com/wiki/contents/articles/32333.sharepoint-online-spomod-installation-guide.aspx
# --------------------------------------------------------------------------------------------------------------------
#
#
#Specify tenant admin and site URL  
$User = "crmusrmx01sr@cemex.onmicrosoft.com"  
$Password = '2018Cemex'  
$SiteURL = "https://cemex.sharepoint.com/sites/AutomationTestReports/"
$Folder = ".\TestResults\csv\*.csv"  
#Path where you want to Copy  
$DocLibName = "Documents"
$FolderName = "Test_Reports"  
#Docs library  
# Add references to SharePoint client assemblies and authenticate to Office 365 site - required  for CSOM  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
#  Bind to site collection  
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)  
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User, (ConvertTo-SecureString $Password -AsPlainText -Force))  
$Context.Credentials = $Creds  
# Retrieve list  
$List = $Context.Web.Lists.GetByTitle($DocLibName)  
#$Context.Load($List)
$Context.Load($List.RootFolder)  
$Context.ExecuteQuery()  
# Upload file  
Foreach($File in (Get-ChildItem $Folder -File))  
{  
    $FileStream = New-Object IO.FileStream($File.FullName, [System.IO.FileMode]::Open)  
    $FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation  
    $FileCreationInfo.Overwrite = $true  
    $FileCreationInfo.ContentStream = $FileStream  
    #$FileCreationInfo.URL = $File
    $FileCreationInfo.URL = $List.RootFolder.ServerRelativeUrl + "/" + $FolderName + "/" + $File.Name  
    $Upload = $List.RootFolder.Files.Add($FileCreationInfo)  
    $Context.Load($Upload)  
    $Context.ExecuteQuery()  
}  

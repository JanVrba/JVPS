# Name : CheckBackupFileCreation.ps1
# Date : 11/07/2016
# Purpose : Scripts Check if backup file was created and send email if not

$backupFolderPath = "C:\temp\Backup"
$timespanSecs = 150

If (-not (Test-BackupFileCreation -backupFolderPath $backupFolderPath -timespanSecs $timespanSecs)) {
    $email = [ordered]@{
        From = "test-wc@gmbg.test"
        To = "jvrba@globebmg.com"  
        Subject = "AH TransactionLog Backup - Error!"       
        Body = "At Folder $backupFolderPath was not Created Transaction log backup longer than $timespanSecs seconds, please check!"        
        SmtpServer =  "192.168.200.243"               
    } # close hashtable
    Send-MailMessage @email    
} # close if 
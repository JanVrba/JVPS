# Name : AH.Environment.ps1
# Date : 27/05/2016
# Purpose : PS DSC - Configuration Data script

$Nodes = $Servers + @( 
             @{ nodeName = "*";
                role = "WebServer";
                AppPool =  'Apply4law';
                environment = @{ GradTest = @{ 
                                    
                                    rootFolder = 'c:\websites\test.apply4law.com\wwwroot';                                                
                                    Website = 'test.apply4law.com'                                             
                               
                                 } ; # close GradTest

                                 GradLive = @{
                                  
                                    rootFolder =  'C:\websites\www.apply4law.com\wwwroot';
                                    Website = 'www.apply4law.com'

                                 } ; # close GradLive

                                 ExpTest = @{ 
                                                
                                    rootFolder =  'c:\websites\test.allhires.com\wwwroot' ;
                                    Website = 'test.allhires.com'
                                                                             
                                 } ; # close ExpTest

                                 ExpLive = @{ 

                                    rootFolder = 'c:\websites\www.allhires.com\wwwroot';                                               
                                    Website =  'www.allhires.com'

                                 }  # close ExpLive

                  } ; # close environment          
                                
              } # close NodeName "*" 
) # close Nodes

$ConfData = @{AllNodes = $Nodes}
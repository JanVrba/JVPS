#
# ConfLive.ps1
#

$Servers =  @(
	@{ nodename = '' }
	#@{ nodename = '' }
	#@{ nodename = '' }
	#@{ nodename = '' }
)

$ADSecurityGroup = ''
$DNS = ''
$gMSAPrefix = ''
$AppPool = ''
$ADusersGroup = ""
$ManagementHost = ""

# Run SQL scripts variables

$SQLDomain = ''
$SQLserverLive = ''
$SQLserverDev = ''
$DBMaster = ''

<# copy shared configuration variables

$ManagementHost = ""
$NlbInterface = ""
$webservers = @("") # ,"","")
$NlbClusterIP = "" #>

# Octopus Deploy variables

$ProjectTemplateID = ""
$projectTemplateName = ""
$ProjectGroupID = ""
$LifecycleId = ""
$OctopusAPIKey = "" 
$OctopusURL = "" 


#
# ConfLive.ps1
#

$Servers =  @(
	@{ nodename = 'wcr2' }
	#@{ nodename = 'w1r2' }
	#@{ nodename = 'w2r2' }
	#@{ nodename = 'w3r2' }
)

$ADSecurityGroup = 'Webservers'
$DNS = 'intranet.gbp.co.uk'
$gMSAPrefix = 'A4L'
$AppPool = 'Apply4law'
$ADusersGroup = "Apply4Law ISUR Users"
$ManagementHost = "wcr2"

# Run SQL scripts variables

$SQLDomain = 'GBP'
$SQLserverLive = 'ws-ah'
$SQLserverDev = 'dev-ws'
$DBMaster = 'Master'

<# copy shared configuration variables

$ManagementHost = "wcr2"
$NlbInterface = ""
$webservers = @("wcr2") # ,"w1r2","w2r2")
$NlbClusterIP = "192.168.200.246" #>

# Octopus Deploy variables

$ProjectTemplateID = "Projects-17"
$projectTemplateName = "COV AllHires Graduate Deploy"
$ProjectGroupID = "ProjectGroups-21"
$LifecycleId = "Lifecycles-22"
$OctopusAPIKey = "API-HUPOX1MN7ZA2X7ZAK9MGEM7PKY" 
$OctopusURL = "http://octopus1" 


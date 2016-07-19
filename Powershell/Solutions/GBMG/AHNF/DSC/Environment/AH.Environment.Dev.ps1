#
# AH.Environment.Dev.ps1
#

$Servers =  @(
	@{ nodename = 'test-wc' },
	@{ nodename = 'test-w1' }
)

# create GMSA variables

$ADSecurityGroup = 'Test_gMSA'
$DNS = 'gmbg.test'
$gMSAPrefix = 'AH'
$AppPool = 'Apply4law'
$ADusersGroup = "Apply4Law ISUR Users"

# Run SQL scripts variables

$SQLDomain = 'Test'
$SQLserverLive = $env:COMPUTERNAME + '\SQLEXPRESS'
$SQLserverDev = $env:COMPUTERNAME + '\SQLEXPRESS'
$DBMaster = 'Master'

# copy shared configuration variables

$ManagementHost = "test-wc"
$NlbInterface = "NLB"
$webservers = @("test-w1","test-w2")
$NlbClusterIP = "192.168.200.246"

# Octopus Deploy variables

$ProjectTemplateID = "Projects-99"
$projectTemplateName = "COV AllHires Graduate Deploy"
$ProjectGroupID = "ProjectGroups-1"
$LifecycleId = "Lifecycles-1"
$OctopusAPIKey = "API-BCNTWSJC2EQ3ULGXET6QPBGUC" 
$OctopusURL = "http://localhost"
$testEnvironmentID = "Environments-41"
$prodEnvironmentID = "Environments-42"
$connStringTest = "data source=dev-ws;initial catalog=apply4law3_dev;password=abcABC123*;persist security info=True;user id=$firmname;workstation id=ojawebsite;packet size=4096"
$connStringProd = "data source=ws-ah.intranet.gbp.co.uk;Network=dbmssocn;Connection Timeout=60;Min Pool Size=0;initial catalog=apply4law3testing16;integrated security=True;application name=www.apply4law.com/$firmname"


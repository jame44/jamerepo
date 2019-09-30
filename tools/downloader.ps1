Param(
   [string] [Parameter(Mandatory=$true)] $username,
   [string] [Parameter(Mandatory=$true)] $password,
   [string] [Parameter(Mandatory=$true)] $Url
)
#Bootstrapping agent in case we need it
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$password = $password | ConvertTo-SecureString -asPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username,$password)

Invoke-WebRequest $Url -Outfile log.txt -Credential $cred

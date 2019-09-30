Param(
   [string] [Parameter(Mandatory=$true)] $username,
   [string] [Parameter(Mandatory=$true)] $password,
   [string] [Parameter(Mandatory=$true)] $Url
)
#Bootstrapping agent in case we need it
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$pair = "${username}:${password}"
$cred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair)

Invoke-WebRequest $Url -Outfile log.txt -Credential $cred

Param(
   [string] [Parameter(Mandatory=$true)] $username,
   [string] [Parameter(Mandatory=$true)] $password,
   [string] [Parameter(Mandatory=$true)] $Url
)
#Bootstrapping agent in case we need it
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$b = [System.Text.Encoding]::UTF8.GetBytes($username + ":" + $password)
$p = [System.Convert]::ToBase64String($b)

$cred = "Basic " + $p

Invoke-WebRequest $Url -Outfile log.txt -Headers @{"Authorization"=$cred}

$a = Get-Content log.txt -Tail 100
$a > log.txt

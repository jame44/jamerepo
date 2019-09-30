Param(
   [string] [Parameter(Mandatory=$true)] $LogFile,
   [string] [Parameter(Mandatory=$true)] $PullRequestId,
   [string] [Parameter(Mandatory=$true)] $Token
)
#Bootstrapping agent in case we need it
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    $Message = [IO.File]::ReadAllText($LogFile)
}
catch {
     $Message = "Error reading the file!!!"
}
$Body = @{
        body = $Message
        }
$Body = $Body | ConvertTo-Json -Depth 2


try {
    Invoke-RestMethod `
         -Uri "https://api.github.com/repos/jame44/jamerepo/issues/$PullRequestId/comments" `
         -Method Post `
         -Headers @{Authorization="Bearer $token"} `
         -Body $Body

} catch {
    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
}

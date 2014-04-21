Import-Module WinCredManager

<#
# Create secure credential file to load anytime.
$username = "guitarrapc"
$credential = Get-Credential -Credential $username
@{
    TargetName = "git:https://github.com"
    userName   = $credential.UserName
    password = ($credential.Password | ConvertFrom-SecureString)
} | ConvertTo-Json -Compress | Out-File -FilePath credGitHub.json -Encoding utf8 -Force
#>

$cred = Get-Content credGitHub.json `
| ConvertFrom-Json | %{
    [PSCustomObject]@{
        targetName = $_.TargetName
        credential = New-Object System.Management.Automation.PSCredential $_.userName, ($_.Password | ConvertTo-SecureString)
    }
}

if ($null -eq (Get-WinCredManagerCredential -TargetName $cred.targetName))
{
    Set-WinCredManagerCredential -TargetName $cred.targetName -Credential $cred.credential
}
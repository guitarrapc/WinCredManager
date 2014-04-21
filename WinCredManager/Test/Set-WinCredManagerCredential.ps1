Import-Module WinCredManager

$credential = Get-Credential
Set-WinCredManagerCredential -TargetName hoge -Credential $credential
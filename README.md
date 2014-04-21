WinCredManager
==========

WinCredManager will manage Set/Get PowerShell Credential with Windows Credential Manager.

- Adapted from [Script Center - Add/Edit Saved Password in Credential Manager (Windows 7) ](http://social.technet.microsoft.com/Forums/scriptcenter/en-US/e91769eb-dbce-4e77-8b61-d3e55690b511/addedit-saved-password-in-credential-manager-windows-7?forum=ITCG)

- Based on [MSDN Blogs / Peer Channel Team Blog - Application Password Security](http://blogs.msdn.com/b/peerchan/archive/2005/11/01/487834.aspx)

# Install

- Let's install now, Open PowerShell or Command prompt, paste the text below and press Enter.

||
|----|
|powershell -NoProfile -ExecutionPolicy unrestricted -Command 'iex ([Text.Encoding]::UTF8.GetString([Convert]::FromBase64String((irm "https://api.github.com/repos/guitarrapc/WinCredManager/contents/WinCredManager/RemoteInstall.ps1").Content))).Remove(0,1)'|

# Functions

You can use Get/Set Windows Credential Manager.

```
Get-Command -Module WinCredManager
```

Here's Cmdlets use in public

|CommandType|Name|ModuleName|
|----|----|----|
|Function| Get-WinCredManagerCredential| WinCredManager|
|Function| Set-WinCredManagerCredential| WinCredManager|

# Set Credential

You can set your Credentianl to Windows Credential Manager with ```Set-WinCredManagerCredential``` function.

```PowerShell
$credential = Get-Credential guitarrapc
Set-WinCredManagerCredential -TargetName "git:https://GitHub.com" -Credential $credential -Type Generic
```

### Result

You will get [boolen] for the result.

### Type

- There are 3 types of credential in Windows Credential Manager. See here for more detail : [Windows Dev Center - Desktop : CredRead function](http://msdn.microsoft.com/en-us/library/windows/desktop/aa374804(v=vs.85).aspx)

# Get Credential

You can get your Credentianl from Windows Credential Manager with ```Get-WinCredManagerCredential``` function.

```PowerShell
Get-WinCredManagerCredential -TargetName "git:https://GitHub.com" -Type Generic
```

### Result

- If credential were found, then you will get specific [PSCredential].

### Type

- There are 3 types of credential in Windows Credential Manager. See here for more detail : [Windows Dev Center - Desktop : CredRead function](http://msdn.microsoft.com/en-us/library/windows/desktop/aa374804(v=vs.85).aspx)
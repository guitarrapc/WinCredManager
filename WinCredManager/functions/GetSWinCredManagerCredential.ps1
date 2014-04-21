#Requires -Version 3.0

function Get-WinCredManagerCredential
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            mandatory = 1,
            position = 0)]
        [string]
        $TargetName,

        [Parameter(
            mandatory = 0,
            position = 1)]
        [ValidateNotNullOrEmpty()]
        [CredType]
        $Type = [CredType]::Generic
    )
 
    $private:ErrorActionPreference = $WinCredManager.errorPreference

    $private:CSPath = Join-Path $WinCredManager.modulePath $WinCredManager.cSharpPath -Resolve
    $private:CredReadCS = Join-Path $CSPath CredRead.cs -Resolve
    $private:sig = Get-Content -Path $CredReadCS -Raw

    $private:addType = @{
        MemberDefinition = $sig
        Namespace        = "Advapi32"
        Name             = "Util"
    }
    Add-TypeMemberDefinition @addType -PassThru `
    | select -First 1 `
    | %{
        $private:typeQualifiedName = $_.AssemblyQualifiedName
        $private:typeFullName = $_.FullName
    }

    $private:nCredPtr= New-Object IntPtr
    if ([System.Type]::GetType($typeQualifiedName)::CredRead($TargetName, $Type.value__, 0, [ref]$nCredPtr))
    {
        $private:critCred = New-Object $typeFullName+CriticalCredentialHandle $nCredPtr
        $private:cred = $critCred.GetCredential()
        $private:username = $cred.UserName
        $private:securePassword = $cred.CredentialBlob | ConvertTo-SecureString -AsPlainText -Force
        $cred = $null
        return New-Object System.Management.Automation.PSCredential $username, $securePassword
    }
    else
    {
        Write-Verbose ("No credentials found in Windows Credential Manager for TargetName: '{0}' with Type '{1}'" -f $TargetName, $Type)
    }
}
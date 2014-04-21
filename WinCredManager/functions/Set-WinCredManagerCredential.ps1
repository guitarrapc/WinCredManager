#Requires -Version 3.0

function Set-WinCredManagerCredential
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
            mandatory = 1,
            position = 1)]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(
            mandatory = 0,
            position = 2)]
        [ValidateNotNullOrEmpty()]
        [CredType]
        $Type = [CredType]::Generic
    )

    $private:ErrorActionPreference = $WinCredManager.errorPreference

    $private:CSPath = Join-Path $WinCredManager.modulePath $WinCredManager.cSharpPath -Resolve
    $private:CredWriteCS = Join-Path $CSPath CredWrite.cs -Resolve
    $private:sig = Get-Content -Path $CredWriteCS -Raw

    $private:domain = $Credential.GetNetworkCredential().Domain
    $private:user = $Credential.GetNetworkCredential().UserName
    $private:password = $Credential.GetNetworkCredential().Password
    switch ([String]::IsNullOrWhiteSpace($domain))
    {
        $true   {$userName = $user}
        $false  {$userName = $domain, $user -join "\"}
    }

    $private:addType = @{
        MemberDefinition = $sig
        Namespace        = "Advapi32"
        Name             = "Util"
    }
    $private:typeName = Add-TypeMemberDefinition @addType -PassThru
    $private:typeFullName = $typeName.FullName | select -Last  1
    $private:typeQualifiedName = $typeName.AssemblyQualifiedName | select -First 1
    
    $private:cred = New-Object $typeFullName
    $cred.flags = 0
    $cred.type = $Type.value__
    $cred.targetName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($TargetName)
    $cred.userName = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($userName)
    $cred.attributeCount = 0
    $cred.persist = 2
    $cred.credentialBlobSize = [System.Text.Encoding]::Unicode.GetBytes($password).length
    $cred.credentialBlob = [System.Runtime.InteropServices.Marshal]::StringToCoTaskMemUni($password)
    $private:result = [System.Type]::GetType($typeQualifiedName)::CredWrite([ref]$cred,0)

    if ($true -eq $result)
    {
        return $true
    }
    else
    {
        return $false
    }
}
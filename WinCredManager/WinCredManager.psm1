#Requires -Version 3.0

Write-Verbose "Loading WinCredManager.psm1"

# WinCredManager
#
# Copyright (c) 2013 guitarrapc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


#-- Public Loading Module Custom Configuration Functions --#

function Import-WinCredManagerConfiguration
{

    [CmdletBinding()]
    param
    (
        [string]
        $configdir = $WinCredManager.modulePath
    )

    $ErrorActionPreference = $WinCredManager.errorPreference

    $WinCredManagerConfigFilePath = (Join-Path $configdir $WinCredManager.defaultconfigurationfile)

    if (Test-Path $WinCredManagerConfigFilePath -pathType Leaf) 
    {
        try 
        {
            . $WinCredManagerConfigFilePath
        } 
        catch 
        {
            throw ("Error Loading Configuration from {0}: " -f $WinCredManager.defaultconfigurationfile) + $_
        }
    }
}

function Add-TypeDefinition
{
    [CmdletBinding()]
    param (
        [string]
        $Code,
        [string]
        $ReferencedAssemblies = "Microsoft.CSharp",
        [string]
        $OutputAssembly
    )
 
    $ErrorActionPreference = "Stop"
  
    $params = @{
        ReferencedAssemblies = $ReferencedAssemblies
        IgnoreWarnings = $IgnoreWarnings
    }
 
    if (-not [String]::IsNullOrEmpty($OutputAssembly))
    {
        $params.Add("OutputAssembly", $OutputAssembly)
    }

    $sb = New-Object Text.StringBuilder
    $sb.AppendLine($code) > $null
    $params.Add("TypeDefinition", $sb.ToString())

    Add-Type @params
}

#-- Enum for CredRead/Write Type --#
Add-Type -TypeDefinition @"
    public enum CredType
    {
        Generic           = 1,
        DomainPassword    = 2,
        DomainCertificate = 3
    }
"@

#-- Private Loading Module Parameters --#

# contains default base configuration, may not be override without version update.
$Script:WinCredManager                        = @{}
$WinCredManager.name                          = "WinCredManager"                                         # contains the Name of Module
$WinCredManager.modulePath                    = Split-Path -parent $MyInvocation.MyCommand.Definition
$WinCredManager.helpersPath                   = "\functions\*.ps1"                                       # path of functions
$WinCredManager.cSharpPath                    = "\functions\cs"                                          # path of CSharp
$WinCredManager.credentialPath                = "\save"                                                  # path of credential
$WinCredManager.context                       = New-Object System.Collections.Stack                      # holds onto the current state of all variables

$WinCredManager.originalErrorActionPreference = $ErrorActionPreference
$WinCredManager.errorPreference               = "Stop"
$WinCredManager.originalDebugPreference       = $DebugPreference
$WinCredManager.debugPreference               = "SilentlyContinue"

# -- Export Modules when loading this module -- #
Resolve-Path (Join-Path $WinCredManager.modulePath $WinCredManager.helpersPath) `
    | where { -not ($_.ProviderPath.Contains(".Tests.")) } `
    | % { . $_.ProviderPath }

# -- Import Default configuration file -- #
Import-WinCredManagerConfiguration

#-- Export Modules when loading this module --#

Export-ModuleMember `
    -Cmdlet * `
    -Function * `
    -Variable * `
    -Alias *
$script:module = "WinCredManager"
$script:moduleVersion = "1.0.0"
$script:description = "PowerShell Windows Credential Manager Setter/Getter";
$script:copyright = "12/Mar/2014 -"
$script:RequiredModules = @()
$script:clrVersion = "4.0.0.0"

$script:functionToExport = @(
    "Get-WinCredManagerCredential",
    "Set-WinCredManagerCredential"
)

$script:variableToExport = "WinCredManager"

$script:moduleManufest = @{
    Path = "$module.psd1";
    Author = "guitarrapc";
    CompanyName = "guitarrapc"
    Copyright = ""; 
    ModuleVersion = $moduleVersion
    Description = $description
    PowerShellVersion = "3.0";
    DotNetFrameworkVersion = "4.0";
    ClrVersion = $clrVersion;
    RequiredModules = $RequiredModules;
    NestedModules = "$module.psm1";
    CmdletsToExport = "*";
    FunctionsToExport = $functionToExport
    VariablesToExport = $variableToExport;
    AliasesToExport = "*";
}

New-ModuleManifest @moduleManufest
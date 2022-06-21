<#
.Synopsis
    Wraps PowerShell in a Windows Batch Script
.Description
    Wraps PowerShell in a Windows Batch Script
#>
param(
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ScriptInfo')]
[Management.Automation.ExternalScriptInfo]
$ScriptInfo,

[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ScriptBlock')]
[ScriptBlock]
$ScriptBlock,

# If set, will use PowerShell core (pwsh.exe).  If not, will use Windows PowerShell (powershell.exe)
[switch]
$Pwsh
)

process {
    $powerShellExe = if ($pwsh) { 'pwsh' } else { 'powershell'} 
    switch ($PSCmdlet.ParameterSetName) 
    {
        ScriptBlock {
@"
@echo off
$powerShellExe -noprofile -nologo -command "& {$($ScriptBlock -replace '"', '\"')} %* ; if (`$error.Count) { exit 1}"
"@
            
        }
        ScriptInfo {
            @"
@echo off
$powerShellExe -noprofile -nologo -command "& '%~dp0$($ScriptInfo.Name)' %*; if (`$error.Count) { exit 1}"
"@                
        }        
    }
}


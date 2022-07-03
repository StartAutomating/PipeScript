<#
.Synopsis
    Gets Module Exports
.Description
    Gets Exported Commands from a module.
.EXAMPLE
    .> {
        $PipeScriptModule = Get-Module PipeScript
        $exports = [ModuleExports()]$PipeScriptModule
        $exports
    }
#>
[CmdletBinding(DefaultParameterSetName='None',PositionalBinding=$false)]
[ValidateScript({
    $val = $_
    if (
        ($val.Parent -is [Management.Automation.Language.AttributedExpressionAst]) -and 
        ($val.Parent.Attribute.TypeName.Name -in 'ModuleExport', 'GetExport', 'GetExports', 'ListExports', 'ModuleExport', 'GetModuleExport', 'GetModuleExports')
    ) {
        return $true
    }
    return $false
})]
[Alias('GetExport','GetExports', 'ListExport','ListExports','ModuleExport','GetModuleExport', 'GetModuleExports')]
param(
# The command type
[Parameter(Position=0)]
[Management.Automation.CommandTypes[]]
$CommandType = @('Alias','Function','Cmdlet'),

# A VariableExpression.  This variable must contain a module.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {

$var = $VariableAST.Extent.ToString()
[scriptblock]::Create($(
{
@(
if ($var -isnot [Management.Automation.PSModuleInfo]) {
    Write-Error "'$var' must be a [Management.Automation.PSModuleInfo]"
} elseif ($var.ExportedCommands.Count) {
    foreach ($cmd in $var.ExportedCommands.Values) {        
        if ($cmd.CommandType -in $CommandType) {
            $cmd
        }
    }
} else {
    foreach ($cmd in $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Function,Cmdlet', $true)) {
        if ($cmd.Module -ne $var) { continue }
        if ($CommandType -contains 'Alias' -and $cmd.ScriptBlock.Attributes.AliasNames) {
            foreach ($aliasName in $cmd.ScriptBlock.Attributes.AliasNames) {
                $ExecutionContext.SessionState.InvokeCommand.GetCommand($aliasName, 'Alias')
            }
        }
        if ($CommandType -contains $cmd.CommandType) {
            $cmd
        }
    }
})
} -replace '\$var', "$var" -replace '\$CommandType', "'$($CommandType -join "','")'"))
}
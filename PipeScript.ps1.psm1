[Include('*-*')]$psScriptRoot

$aliasNames = @()
foreach ($transpilerCmd in Get-Transpiler) {
    $aliasNames += ".>$($transpilerCmd.DisplayName)"
    Set-Alias ".>$($transpilerCmd.DisplayName)" Use-PipeScript
    $aliasNames += ".<$($transpilerCmd.DisplayName)>"
    Set-Alias ".<$($transpilerCmd.DisplayName)>" Use-PipeScript
}

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasNames +=
    [GetExports("Alias")]$MyModule

Export-ModuleMember -Function * -Alias $aliasNames
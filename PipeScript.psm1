foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    if ($file.Name -match '\.[^\.]\.ps1$') { continue }  # Skip if the file is an unrelated file.
    . $file.FullName
}

$transpilerNames = Get-Transpiler | Select-Object -ExpandProperty DisplayName
$aliasList +=
    
    @(foreach ($alias in @($transpilerNames)) {
        Set-Alias ".>$alias" "Use-PipeScript" -PassThru:$True
    })
    

$aliasList +=
    
    @(foreach ($alias in @($transpilerNames)) {
        Set-Alias ".<$alias>" "Use-PipeScript" -PassThru:$True
    })
    

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
$aliasList +=
    
    @(
    if ($MyModule -isnot [Management.Automation.PSModuleInfo]) {
        Write-Error "'$MyModule' must be a [Management.Automation.PSModuleInfo]"
    } elseif ($MyModule.ExportedCommands.Count) {
        foreach ($cmd in $MyModule.ExportedCommands.Values) {        
            if ($cmd.CommandType -in 'Alias') {
                $cmd
            }
        }
    } else {
        foreach ($cmd in $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Function,Cmdlet', $true)) {
            if ($cmd.Module -ne $MyModule) { continue }
            if ('Alias' -contains 'Alias' -and $cmd.ScriptBlock.Attributes.AliasNames) {
                foreach ($aliasName in $cmd.ScriptBlock.Attributes.AliasNames) {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($aliasName, 'Alias')
                }
            }
            if ('Alias' -contains $cmd.CommandType) {
                $cmd
            }
        }
    })
    

Export-ModuleMember -Function * -Alias $aliasList

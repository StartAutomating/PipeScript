foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1') { continue }
    . $file.FullName
}        

$aliasNames = @()
foreach ($transpilerCmd in Get-Transpiler) {
    $aliasNames += ".>$($transpilerCmd.DisplayName)"
    Set-Alias ".>$($transpilerCmd.DisplayName)" Use-PipeScript
    $aliasNames += ".<$($transpilerCmd.DisplayName)>"
    Set-Alias ".<$($transpilerCmd.DisplayName)>" Use-PipeScript
}

foreach ($cmd in $ExecutionContext.SessionState.InvokeCommand.GetCommands('*','Function', $true)) {
    if ($cmd.ScriptBlock.Attributes.AliasNames) {
        $aliasNames += $cmd.ScriptBlock.Attributes.AliasNames
    }
}

Export-ModuleMember -Function * -Alias $aliasNames

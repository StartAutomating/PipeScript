foreach ($file in (Get-ChildItem -Path "$psScriptRoot" -Filter "*-*" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    if ($file.Name -match '\.ps1\.ps1$') { continue }  # Skip if the file is a source generator.
    . $file.FullName
}

$aliasNames = @()
foreach ($transpilerCmd in Get-Transpiler) {
    $aliasNames += ".>$($transpilerCmd.DisplayName)"
    Set-Alias ".>$($transpilerCmd.DisplayName)" Use-PipeScript
    $aliasNames += ".<$($transpilerCmd.DisplayName)>"
    Set-Alias ".<$($transpilerCmd.DisplayName)>" Use-PipeScript
}

$MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
foreach ($cmd in $ExecutionContext.SessionState.InvokeCommand.GetCommands('*','Function', $true)) {
    if ($cmd.ScriptBlock.Module -ne $MyModule) { continue }
    if ($cmd.ScriptBlock.Attributes.AliasNames) {
        $aliasNames += $cmd.ScriptBlock.Attributes.AliasNames
    }
}

Export-ModuleMember -Function * -Alias $aliasNames

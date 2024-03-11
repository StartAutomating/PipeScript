<#
.SYNOPSIS
    Gets the commands a module serves.
.DESCRIPTION
    Gets the commands served by the module.
#>
param()
$cmdPatternList = @(foreach ($serviceInfo in $this.List) {
    if ($serviceInfo.Command) {
        [Regex]::Escape($serviceInfo.Command)
    } elseif ($serviceInfo.CommandPattern) {
        $serviceInfo.CommandPattern
    }
})
$CmdPatternRegex = [Regex]::new("(?>$($cmdPatternList -join '|'))", 'IgnoreCase,IgnorePatternWhitespace','00:00:00.1')

$ExecutionContext.SessionState.InvokeCommand.GetCommands('*','Function,Cmdlet,Alias', $true) -match $CmdPatternRegex
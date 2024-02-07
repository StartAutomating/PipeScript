<#
.SYNOPSIS
    Determines if a language has a PowerShell interpreter
.DESCRIPTION
    Determines if a language's interpreter is PowerShell or an external application.
.NOTES
    Returns $true is the interpreter is a `[ScriptBlock]`, `[FunctionInfo]`, or `[CmdletInfo]`,
    or an `[AliasInfo]` that does not point to an application.  Otherwise, returns $false.
#>
if ($this.Interpreter -is [scriptblock]) {
    return $true
}
if ($this.Interpreter -is [Management.Automation.FunctionInfo]) {
    return $true
}
if ($this.Interpreter -is [Management.Automation.CmdletInfo]) {
    return $true
}
if ($this.Interpreter -is [Management.Automation.AliasInfo] -and
    $this.Interpreter.ResolvedCommand -isnot [Management.Automation.ApplicationInfo]) {
    return $true
}
return $false

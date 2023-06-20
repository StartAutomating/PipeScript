<#
.SYNOPSIS
    Gets display names.
.DESCRIPTION
    Gets the display name of a PipeScript command.
#>
if (-not $this.'.DisplayName') {
    if (-not $script:PipeScriptModuleCommandPattern) {
        $script:PipeScriptModuleCommandPattern = Aspect.ModuleCommandPattern -Module PipeScript   
    }
    if ($script:PipeScriptModuleCommandPattern) {
        $displayName = $this.Name -replace $script:PipeScriptModuleCommandPattern
        if (-not $displayName) {
            $displayName = $this.Name
        }
        Add-Member NoteProperty '.DisplayName' -InputObject $this -Value $displayName -Force
    }
}
$this.'.DisplayName'


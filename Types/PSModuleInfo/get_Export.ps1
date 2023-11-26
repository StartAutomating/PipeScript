<#
.SYNOPSIS
    Gets a module's exports
.DESCRIPTION
    Gets everything a module exports or intends to export.

    This combines the various `.Exported*` properties already present on a module.
    
    It also adds anything found in a manifest's `.PrivateData.Export(s)` properties,
    as well as anything in a manifest's  `.PrivateData.PSData.Export(s)`.
.NOTES
    This property serves two major purposes:

    1. Interacting with all of the exports from any module in a consistent way
    2. Facilitating exporting additional content from modules, such as classes.
#>
param()
$(
    if ($this.ExportedCommands.Count) {
        $this.ExportedCommands.Values
    } elseif (-not $this.ExportedVariables.Count) {
        foreach ($loadedCommand in $ExecutionContext.SessionState.InvokeCommand.GetCommands("*","Alias,Function,Cmdlet",$true)) {
            if ($loadedCommand.Module -eq $this) {
                $loadedCommand
            }
        }
    }   
),
$this.ExportedDSCResources.Values,
$this.ExportedTypeFiles,
$this.ExportedFormatFiles,
$this.ExportedVariables,
$this.PrivateData.Export,
$this.PrivateData.Exports,
$this.PrivateData.PSData.Export,
$this.PrivateData.PSData.Exports -ne $null | 
    & { process { if ($_) { $_ } } }
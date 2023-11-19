<#
.SYNOPSIS
    Gets a file in a module        
.DESCRIPTION
    Gets a file located within a module.
    
    Hidden files are ignored.
.EXAMPLE
    (Get-Module PipeScript).File(".\PipeScript.psd1")
#>
param()
foreach ($arg in $args) {
    $shouldRecurse = ($arg -match "^\.\\") -as [bool]
    $this | Split-Path | Get-ChildItem -File -Recurse -Path $arg -Recurse:$shouldRecurse
}
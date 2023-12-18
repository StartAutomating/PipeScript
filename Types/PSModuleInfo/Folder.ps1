<#
.SYNOPSIS
    Gets a folder in a module        
.DESCRIPTION
    Gets a folder located within a module.
    
    Hidden folders are ignored.
.EXAMPLE
    (Get-Module PipeScript).Folder(".\Build")
#>
param()

foreach ($arg in $args) {
    $shouldRecurse = ($arg -match "^\.\\") -as [bool]
    $this | Split-Path | Get-ChildItem -Directory -Recurse -Path $arg -Recurse:$shouldRecurse
}
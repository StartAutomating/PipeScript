<#
.SYNOPSIS
    Gets all folders in a module        
.DESCRIPTION
    Gets all of the file folders located within a module.
    
    Hidden folders are ignored.
.EXAMPLE
    (Get-Module PipeScript).Folders
#>
param()
$this | Split-Path | Get-ChildItem -Directory -Recurse

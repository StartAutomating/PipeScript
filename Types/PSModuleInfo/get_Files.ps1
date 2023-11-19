<#
.SYNOPSIS
    Gets all files in a module        
.DESCRIPTION
    Gets all of the files located within a module.
    
    Hidden files are ignored.
.EXAMPLE
    (Get-Module PipeScript).Files
#>
param()
$this | Split-Path | Get-ChildItem -File -Recurse

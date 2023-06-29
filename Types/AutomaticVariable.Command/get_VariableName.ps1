<#
.SYNOPSIS
    Gets the automatic variable name
.DESCRIPTION
    Gets the name of an automatic variable that is defined in an Automatic?Variable* command.
#>
$this -replace '(?>Magic|Automatic)\p{P}Variable\p{P}' -replace 
    '^(?>PowerShell|PipeScript)' -replace
    '^\p{P}' -replace '\p{P}$'

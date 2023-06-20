<#
.SYNOPSIS
    Sets display names.
.DESCRIPTION
    Sets the display name of a PipeScript command.
#>
param(
[string]
$DisplayName
)
Add-Member NoteProperty '.DisplayName' -InputObject $this -Value $DisplayName -Force
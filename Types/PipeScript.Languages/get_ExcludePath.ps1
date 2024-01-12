<#
.SYNOPSIS
    Gets Excluded Paths for all languages.
.DESCRIPTION
    Gets any excluded paths for interpreted languages in PipeScript.

    If a command is like any of these paths, it should not be interpreted.
#>
param()

if ($null -eq $this.'.ExcludePath'.Length) {
    Add-Member -InputObject $this -Force -MemberType NoteProperty -Name '.ExcludePath' -Value @()
}

return $this.'.ExcludePath'
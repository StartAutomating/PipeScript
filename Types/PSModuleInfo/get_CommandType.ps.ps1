<#
.SYNOPSIS
    Gets Module Command Types
.DESCRIPTION
    Gets Command Types defined within a Module
.EXAMPLE
    (Get-Module PipeScript).CommandType
#>
param()

if (-not $this.'.CommandTypes') {
    Add-Member -InputObject $this -MemberType NoteProperty -Force -Name '.CommandTypes' (
        Aspect.ModuleCommandType -Module $this
    )        
}
$this.'.CommandTypes'

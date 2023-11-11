<#
.SYNOPSIS
    Gets Extended Commands
.DESCRIPTION
    Gets Extended Commands for this module
.EXAMPLE
    (Get-Module PipeScript).Extensions
#>
if (-not $this.'.ExtendedCommands') {
    Add-Member -InputObject $this -MemberType NoteProperty -Name '.Extensions' -Value @(
        $this.FindExtensions()    
        $this.FindExtensions(($This | Split-Path))        
    )
}
$this.'.ExtendedCommands'

<#
.SYNOPSIS
    Does a Language Have an Interpreter?
.DESCRIPTION
    Returns true if a language defined an interpreter.
#>
return ($this.Interpreter -as [bool])

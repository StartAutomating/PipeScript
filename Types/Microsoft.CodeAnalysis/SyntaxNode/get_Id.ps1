<#
.SYNOPSIS
    Gets the Identifier of a Syntax Node. 
.DESCRIPTION
    Gets a [string] Identifier of a CSharp syntax node
#>
if ($this.Identifier) {
    "$($this.Identifier)"
}
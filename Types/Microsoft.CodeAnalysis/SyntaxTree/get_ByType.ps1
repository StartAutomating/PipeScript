<#
.SYNOPSIS
    Gets CSharp AST Nodes by type
.DESCRIPTION
    Gets a dictionary of all nodes in a CSharp AST beneath this point, grouped by type.
.EXAMPLE
    (Parse-CSharp '"Hello World";').ByType
#>


$this.Root.ByType

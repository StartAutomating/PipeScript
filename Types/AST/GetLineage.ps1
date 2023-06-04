<#
.SYNOPSIS
    Gets AST Lineage
.DESCRIPTION
    Gets the Lineage of an Abstract Syntax Tree element.
    
    The Lineage is all of the Abstract Syntax Tree's parents.
#>
$thisParent = $this.Parent
while ($thisParent) {
    $thisParent
    $thisParent  = $thisParent.Parent
}

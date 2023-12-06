<#
.SYNOPSIS
    Gets the first nested AST
.DESCRIPTION
    Gets the first nested element of this AST
.EXAMPLE
    {
        do { } while ($false)
    }.First
#>
param()
$this.FirstElements(1)

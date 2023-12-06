<#
.SYNOPSIS
    Gets the First N elements in an AST
.DESCRIPTION
    Gets the First N elements within an AST, excluding this element.
#>
param(
# The number of elements to get.  By default, one.
[int]
$NumberOfElements = 1
)


$foundElementCount = 0
foreach ($foundElement in $this.FindAll({$true}, $true)) {
    if (-not $foundElementCount) {
        $foundElementCount++
        continue
    }
    if ($foundElementCount -le $NumberOfElements) {
        $foundElementCount++
        $foundElement        
    } else {
        break
    }    
}

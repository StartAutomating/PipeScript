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
    # We want to skip named blocks in this case, as we're really after the first "real" element.
    if ($foundElement -is [Management.Automation.Language.NamedBlockAst]) {
        continue
    }
    if ($foundElementCount -le $NumberOfElements) {
        $foundElementCount++
        $foundElement        
    } else {
        break
    }    
}

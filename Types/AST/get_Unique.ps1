<#
.SYNOPSIS
    Gets unique AST elements
.DESCRIPTION
    Gets unique AST elements.  Uniqueness is defined by being literally the same text.
#>
$uniqueElements = [Ordered]@{}
foreach ($foundElement in @($this.FindAll({$true},$true))) {    
    if ($uniqueElements["$foundElement"]) {
        continue
    }
    $uniqueElements["$foundElement"] = $foundElement
}

@($uniqueElements.Values)

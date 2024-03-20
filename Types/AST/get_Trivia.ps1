<#
.SYNOPSIS
    Gets an AST's Trivia
.DESCRIPTION
    Gets an AST's Trivia.  This is any documentation directly before this ast element.
#>
param()

if (-not $this.Parent) { return }


$relativeIndex = $this.GetRelativeIndex()
if (-not $relativeIndex.Collection) { return }
$thisCollection = $relativeIndex.Collection
$thisIndex = $relativeIndex.Index

# For the first parameter,
if ($thisIndex -eq 0) { 
    $parentExtent = $this.Parent.Extent.ToString()
    # this starts after the first parenthesis (if present)
    $afterFirstParens = $parentExtent.IndexOf('(') + 1
    # and goes until the start of the parameter
    $parentExtent.Substring($afterFirstParens, 
        $this.Extent.StartOffset - 
            $this.Parent.Extent.StartOffset - 
                $afterFirstParens) -replace '^[\s\r\n]+'
    # (don't forget to trim leading whitespace).
} else {
    # For every other parameter it is the content between parameters.
    $lastItem        = $thisCollection[$thisIndex - 1]
    $relativeOffset  = $lastItem.Extent.EndOffset + 1 - $this.Parent.Extent.StartOffset
    $distance        = $this.Extent.StartOffset - $lastItem.Extent.EndOffset - 1
    # (don't forget to trim leading whitespace and commas)
    $this.Parent.Extent.ToString().Substring($relativeOffset,$distance) -replace '^[\,\s\r\n]+'
}

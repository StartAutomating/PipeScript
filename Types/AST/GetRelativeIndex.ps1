
$thisCollection,$thisIndex = $null,-1     
:FindThisIndex foreach ($parentProperty in $this.Parent.psobject.Properties) {
    if ($parentProperty -is [PSScriptProperty] -or $parentProperty -is [PSNoteProperty]) {
        continue FindThisIndex
    }
    $currentProperty = $this.Parent.($parentProperty.Name)
    if (-not $currentProperty.IndexOf) { continue }

    
    if ($currentProperty.IndexOf($this) -ge 0) {
        $thisCollection = $currentProperty
        $thisIndex = $thisCollection.IndexOf($this)
        break FindThisIndex
    }

}

return ([PSCustomObject][Ordered]@{
    Collection = $thisCollection
    Index = $thisIndex
})
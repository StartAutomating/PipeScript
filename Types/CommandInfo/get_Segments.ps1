$allMatches = @($this.Separator.Matches($this.FullyQualifiedName))
@(
    # All namespaces are a series of matches
    foreach ($matched in $allMatches) {
        $this.FullyQualifiedName.Substring($matched.Index)
    }
    if ($matched.Index -gt 0) {
        $this.FullyQualifiedName
    }
) -as [string[]]
$allMatches = @($this.Separator.Matches($this.FullName))
@(
    # All namespaces are a series of matches
    foreach ($matched in $allMatches) {
        $this.FullName.Substring($matched.Index)
    }
    if ($matched.Index -gt 0) {
        $this.FullName
    }
) -as [string[]]
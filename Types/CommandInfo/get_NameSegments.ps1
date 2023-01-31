$allMatches = @($this.NameSeparator.Matches($this.FullName))
@(
    # All namespaces are a series of matches
    foreach ($matched in $allMatches) {
        $this.FullName.Substring($matched.Index)
    }
    $this.FullName
) -as [string[]]
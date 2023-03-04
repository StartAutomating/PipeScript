$matched = $this.Separator.Match($this.FullyQualifiedName)
if ($matched.Success -and $matched.Index -gt 0) {
    $this.FullyQualifiedName.Substring(0,$matched.Index)
}
else {
    ''
}




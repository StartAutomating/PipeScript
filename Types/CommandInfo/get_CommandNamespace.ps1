$matched = $this.Separator.Match($this.FullName)
if ($matched.Success -and $matched.Index -gt 0) {
    $this.FullName.Substring(0,$matched.Index)
}
else {
    ''
}




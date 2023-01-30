if ($this -is [Management.Automation.CmdletInfo]) {    
    $this.Namespace
} else {
    $matched = $this.NamespaceSeparator.Match($this.Name)
    if ($matched.Success -and $matched.Index -gt 0) {
        $this.Name.Substring(0,$matched.Index)
    }
    else {
        ''
    }
}



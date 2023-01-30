if ($this -is [Management.Automation.CmdletInfo]) {    
    return $this.Namespace
} 

$fullName = 
    if ($this -is [Management.Automation.ExternalScriptInfo]) {
        $this.Source
    } elseif ($this.Module) {
        '' + $this.Module + '\' + $this.Name        
    } else {
        $this.Name
    }

$matched = $this.NamespaceSeparator.Match($fullName)
if ($matched.Success -and $matched.Index -gt 0) {
    $this.Name.Substring(0,$matched.Index)
}
else {
    ''
}




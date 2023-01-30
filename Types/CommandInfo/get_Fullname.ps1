if ($this -is [Management.Automation.ExternalScriptInfo]) {
    $this.Source
} elseif ($this.Module) {
    '' + $this.Module + '\' + $this.Name
} 
elseif ($this -is [Management.Automation.CmdletInfo]) {
    $this.ImplementingType.Namespace + '.' + $this.Name
}
else {
    $this.Name
}
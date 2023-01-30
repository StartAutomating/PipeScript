if ($this -is [Management.Automation.ExternalScriptInfo] -or 
    $this -is [Management.Automation.ApplicationInfo]) {
    if ($this.Root -and 
        $this.Source.StartsWith -and 
        $this.Source.StartsWith($this.Root, "OrdinalIgnoreCase")) {
        $this.Source.Substring($this.Root)
    } else {
        $this.Source
    }    
}
elseif ($this.Module) {
    '' + $this.Module + '\' + $this.Name
} 
elseif ($this -is [Management.Automation.CmdletInfo]) {
    $this.ImplementingType.Namespace + '.' + $this.Name
}
else {
    $this.Name
}
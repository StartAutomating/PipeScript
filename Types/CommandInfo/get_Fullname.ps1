if ($this -is [Management.Automation.ExternalScriptInfo]) {
    $this.Source
} elseif ($this.Module) {
    '' + $this.Module + '\' + $this.Name
} else {
    $this.Name
}
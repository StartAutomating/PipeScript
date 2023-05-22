if ($this -is [Manangement.Automation.AliasInfo]) {
    $resolveThis = $this
    while ($resolveThis.ResolvedCommand) {
        $resolveThis = $resolveThis.ResolvedCommand
    }
    if ($resolveThis) {
        @($resolveThis.GetHelpField("Description"))[0] -replace '^\s+'
    }
} else {
    @($this.GetHelpField("Description"))[0] -replace '^\s+'
}

# Most variables we will not know the value of until we have run.
# the exceptions to the rule are:  $true, $false, and $null
if ($this.variablePath.userPath -in 'true', 'false', 'null') {
    $ExecutionContext.SessionState.PSVariable.Get($this.variablePath).Value
} else {
    $this
}

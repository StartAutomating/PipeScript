if ($this.variablePath.userPath -in 'true', 'false', 'null') {
    $ExecutionContext.SessionState.PSVariable.Get($this.variablePath).Value
} else {
    $this
}

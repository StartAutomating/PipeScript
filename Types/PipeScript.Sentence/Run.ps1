if (-not $this.Keyword) {
    throw "Sentence lacks a keyword"
}

if (-not $this.Command) {
    throw "Sentence has no command"
}

$parameters = $this.Parameters
$arguments  = $this.Arguments

if (-not $parameters -and -not $arguments) {
    & $this.Command
}
elseif (-not $arguments) {
    & $this.Command @parameters
}
elseif (-not $parameters) {
    & $this.Command @arguments
}
else {
    & $this.Command @arguments @parameters
}



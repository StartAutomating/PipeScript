
$commandName = $this.CommandElements[0].ToString()
$foundTranspiler = Get-Transpiler -TranspilerName $commandName
if ($foundTranspiler) {
    foreach ($transpiler in $foundTranspiler) {
        if ($transpiler.Validate($this)) { 
            $transpiler
        }
    }
} else {
    $ExecutionContext.SessionState.InvokeCommand.GetCommands($commandName, 'All', $true)
}



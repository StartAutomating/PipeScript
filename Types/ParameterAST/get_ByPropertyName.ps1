foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [Management.Automation.ParameterAttribute]) {
        continue
    }
    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -ne 'ValueFromPipelineByPropertyName') {
            continue            
        }
        if ($namedArgument.Argument -and $namedArgument.Argument.Value) {
            return $true
        } elseif (-not $namedArgument.Argument) {
            return $true
        }
    }
}

return $false
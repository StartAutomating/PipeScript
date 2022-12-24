$parameterSetNames = @(foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [Management.Automation.ParameterAttribute]) {
        continue
    }
    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'ParameterSetName') {
            $namedArgument.Argument.Value
        }
    }
})

if ($parameterSetNames) {
    $parameterSetNames -as [string[]]
} else {
    "__AllParameterSets" -as [string[]]
}
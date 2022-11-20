$positions = @(
:nextAttribute foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [Management.Automation.ParameterAttribute]) {
        continue
    }
    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'Position') {
            $namedArgument.Argument.Value
            continue nextAttribute
        }
    }
})

if ($positions.Length -gt 1) {
    $positions -as [int[]]
} elseif ($positions) {
    $positions[0]
} else {
    $null
}
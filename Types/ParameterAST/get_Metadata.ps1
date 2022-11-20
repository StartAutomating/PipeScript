$metadata = [Ordered]@{}

foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [Reflection.AssemblyMetadataAttribute]) {
        continue
    }
    $key, $value =
        foreach ($positionalParameter in $attr.PositionalArguments) {
            $positionalParameter.Value
        }

    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'Key') {
            $key = $namedArgument.Argument.Value
        }
        elseif ($namedArgument.ArgumentName -eq 'Value') {
            $value = $namedArgument.Argument.Value
        }
    }
    if (-not $metadata[$key]) {
        $metadata[$key] = $value
    } else {
        $metadata[$key] = @($metadata[$key]) + $value
    }
}

return $metadata
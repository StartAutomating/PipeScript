foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [ComponentModel.DisplayNameAttribute]) {
        continue
    }
    
    foreach ($positionalParameter in $attr.PositionalArguments) {
        return $positionalParameter.Value
    }

    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'DisplayName') {
            return $namedArgument.Argument.Value
        }
    }
}

return $this.Name.VariablePath.ToString()
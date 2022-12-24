$isBindable = $false
foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [ComponentModel.DefaultBindingPropertyAttribute]) {
        if ($reflectedType -eq [ComponentModel.BindableAttribute]) {
            if ($attr.PositionalArguments.Value -eq $false) {
                return ''
            } else {
                $isBindable = $true
            }
        }
        continue
    }
    
    foreach ($positionalParameter in $attr.PositionalArguments) {
        return $positionalParameter.Value
    }

    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'Name') {
            return $namedArgument.Argument.Value
        }
    }    
}


if ($isBindable) {
    return $this.Name.VariablePath.ToString()
} else {
    return ''
}
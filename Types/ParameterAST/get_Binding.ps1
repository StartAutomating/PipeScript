$isBindable = $false
foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ((-not $reflectedType) -or 
        $reflectedType -notin [ComponentModel.DefaultBindingPropertyAttribute],
        [ComponentModel.BindableAttribute],
        [ComponentModel.ComplexBindingPropertiesAttribute]) {        
        continue
    }
    
    $positionalArguments = @(
        foreach ($positionalParameter in $attr.PositionalArguments) {
            $positionalParameter.Value
        }
    )
    $realAttribute = 
        if ($positionalArguments) {
            $reflectedType::new($positionalArguments)
        } else {
            $reflectedType::new()
        }
    
    
    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'Name') {
            $realAttribute.$($namedArgument.ArgumentName) = $namedArgument.Argument.Value
        }
    }
    $realAttribute
}

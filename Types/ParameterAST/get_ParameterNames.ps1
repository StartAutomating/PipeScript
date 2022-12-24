@(foreach ($attr in $this.Attributes) {
    $reflectedType = $attr.TypeName.GetReflectionType()
    if ($reflectedType -ne [Alias]) {        
        continue
    }
    
    foreach ($positionalParameter in $attr.PositionalArguments) {
        $positionalParameter.Value
    }

    foreach ($namedArgument in $attr.NamedArguments) {
        if ($namedArgument.ArgumentName -eq 'AliasNames') {
            $namedArgument.Argument.Value
        }
    }    
}

$this.Name.VariablePath.ToString())
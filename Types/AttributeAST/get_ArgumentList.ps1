$Parameter    = [Ordered]@{}
$ArgumentList = @()
# Collect all of the arguments of the attribute, in the order they were specified.
$argsInOrder = @(
    @($this.PositionalArguments) + @($this.NamedArguments) | 
    Sort-Object { $_.Extent.StartOffset}
)


# Now we need to map each of those arguments into either named or positional arguments.
foreach ($attributeArg in $argsInOrder) {
    # Named arguments are fairly straightforward:                                
    if ($attributeArg -is [Management.Automation.Language.NamedAttributeArgumentAst]) {
        $argName = $attributeArg.ArgumentName
        $argAst  = $attributeArg.Argument
        $parameter[$argName] =
            if ($argName -eq $argAst) { # If the argument is the name,
                $true # treat it as a [switch] parameter.
            }
            # If the argument value was an ScriptBlockExpression
            else {
                $argAst
            }                        
    } else {
        # If we are a positional parameter, for the moment:
        if ($parameter.Count) {
            # add it to the last named parameter.
            $parameter[@($parameter.Keys)[-1]] = 
                @() + $parameter[@($parameter.Keys)[-1]] + $argAst
        } else {
            # Or add it to the list of string arguments.
            $ArgumentList += 
                $attributeArg.ConvertFromAst()                            
        }
    }
}

return $ArgumentList

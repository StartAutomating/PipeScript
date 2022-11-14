

function TypeConstraintToArguments (
    [Parameter(ValueFromPipeline)]
    $TypeName
) {
    begin {
        $TypeNameArgs = @()
        $TypeNameParams = [Ordered]@{}
        
    }
    process {

        if ($TypeName.IsGeneric) {            
            $TypeNameParams[$typeName.TypeName.Name] = 
                $typeName.GenericArguments |
                    TypeConstraintToArguments                        
        } elseif (-not $TypeName.IsArray) {    
            $TypeNameArgs += $TypeName.Name
        }
    }
    end {
        if ($TypeNameParams.Count) {
            $TypeNameParams
        } elseif ($TypeNameArgs) {
            $TypeNameArgs
        }                        
    }
}

if (-not $this.TypeName.IsGeneric) { return @{} }
foreach ($arg in @($this.TypeName.GenericArguments | TypeConstraintToArguments)) {
    if ($arg -is [Collections.IDictionary]) {
        $arg
    }
}

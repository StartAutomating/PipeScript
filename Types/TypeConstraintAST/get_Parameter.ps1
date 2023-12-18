
<#
.SYNOPSIS
    Gets parameters to a type constraint
.DESCRIPTION
    Gets the parameters from a type constraint.

    This will treat any generic type specifiers as potential parameters, and other type specifiers as arguments.
.EXAMPLE
    {
        [a[b[c],c]]'d'
    }.Ast.EndBlock.Statements[0].PipelineElements[0].Expression.Type.Parameters
#>
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

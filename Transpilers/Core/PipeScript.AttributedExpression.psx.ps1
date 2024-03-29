<#
.SYNOPSIS
    The PipeScript AttributedExpression Transpiler 
.DESCRIPTION
    AttributedExpressions will be transpiled 
    
    AttributedExpressions often apply to variables, for instance:

    ```PowerShell
    $hello = 'hello world'
    [OutputFile(".\Hello.txt")]$hello
    ```PowerShell
#>
param(
# The attributed expression
[Parameter(Mandatory,ParameterSetName='AttributedExpressionAst',ValueFromPipeline)]
[Management.Automation.Language.AttributedExpressionAst]
$AttributedExpressionAst
)

begin {
    if (-not $script:TypeAcceleratorsList) {
        $script:TypeAcceleratorsList = [PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get.Keys
    }

    function TypeConstraintToArguments {
        param (
            [Parameter(ValueFromPipeline)]
            $TypeName
        )
        begin {
            $TypeNameArgs = @()
            $TypeNameParams = @{}
        }
        process {

            if ($TypeName.IsGeneric) {
                $TypeNameParams[$typeName.Name] = 
                    $typeName.GenericArguments |
                        UnpackTypeConstraintArgs
            } elseif (-not $TypeName.IsArray) {
                $TypeNameArgs += $TypeName.Name
            }
        }
        end {
            [PSCustomObject]@{
                ArgumentList = $TypeNameArgs
                Parameter    = $TypeNameParams
            }                        
        }
    }
}

process {
    # Determine the typename of this expression
    $typeNameAst = 
        if ($AttributedExpressionAst.Type.TypeName) {
            $AttributedExpressionAst.Type.TypeName
        } elseif ($AttributedExpressionAst.Attribute.Typename) {
            $AttributedExpressionAst.Attribute.Typename
        }

    $IsRealType = $typeNameAst.GetReflectionType()
    $transpilerStepName = "$typeNameAst"

    if ($IsRealType) { return }

    # If the child is another expression
    if ($AttributedExpressionAst.Child -is [Management.Automation.Language.AttributedExpressionAst]) {
        # call recursively to get the output up until this point
        $currentInput = & $MyInvocation.MyCommand.ScriptBlock -AttributedExpressionAst $AttributedExpressionAst.Child
    }
    elseif ($AttributedExpressionAst.Child -is [Management.Automation.Language.TypeExpressionAst]) {

    }
    # Otherwise, 
    else 
    {
        $currentInput = # If the child is a ScriptBlock AST
            if ($AttributedExpressionAst.Child -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                # Create a new script block.
                [ScriptBlock]::Create($AttributedExpressionAst.Child.ScriptBlock -replace '^\{' -replace '\}$')
            }
            elseif ($AttributedExpressionAst.Child -is [Management.Automation.Language.VariableExpressionast]) {
                # Pass the variable AST
                $AttributedExpressionAst.Child
            }
            elseif (
                $AttributedExpressionAst.Child -is [Management.Automation.Language.StringConstantExpressionAst] -or
                $AttributedExpressionAst.Child -is [Management.Automation.Language.ExpandableStringExpressionAst]
            ) {
                if ($AttributedExpressionAst.Child.StringConstantType -eq 'DoubleQuoted') {
                    $ExecutionContext.SessionState.InvokeCommand.ExpandString(
                        $AttributedExpressionAst.Child.Value.ToString()
                    )
                } else {
                    $AttributedExpressionAst.Child.Value.ToString()
                }
            }
    }
    if (-not $AttributedExpressionAst.Attribute -or 
        $AttributedExpressionAst.Attribute -is [Management.Automation.Language.TypeConstraintAst]) {
        $TypeConstraint = $AttributedExpressionAst.Attribute
        $transpilerStepName  = 
            if ($TypeConstraint.TypeName.TypeName) {
                $TypeConstraint.TypeName.TypeName.Name
            } else {
                $TypeConstraint.TypeName.Name
            }
        $foundTranspiler =
            if ($currentInput -isnot [string]) {
                Get-Transpiler -CouldPipe $currentInput -TranspilerName "$transpilerStepName"
            } else {
                Get-Transpiler -TranspilerName "$transpilerStepName"
            }

        $argList = @()
        $parameters = @{}

        if ($TypeConstraint.TypeName.IsGeneric) {
            $TypeConstraint.TypeName.GenericArguments | 
            TypeConstraintToArguments | 
                ForEach-Object {
                    if ($_.ArgumentList) {
                        $arglist += $_.ArgumentList
                    }
                    if ($_.Parameter.Count) {
                        $parameters += $_.Parameter
                    }
                }
        }
        
            
        if ($foundTranspiler -and $currentInput -isnot [string]) {
            $currentInput | Invoke-PipeScript -CommandInfo $foundTranspiler.ExtensionCommand  -ArgumentList $arglist -Parameter $parameters                                          
        } elseif ($foundTranspiler -and $currentInput -is [string]) {
            Invoke-PipeScript -CommandInfo $foundTranspiler.ExtensionCommand -ArgumentList @(@($currentInput) + $arglist) -Parameter $parameters
        } elseif ($script:TypeAcceleratorsList -notcontains $transpilerStepName -and $transpilerStepName -notin 'Ordered') {
            Write-Error "Could not find a Transpiler or Type for [$TranspilerStepName]" -Category ParserError -ErrorId 'Transpiler.Not.Found'
        }
    } else {
        if ($currentInput -isnot [string]) {
            $currentInput | Invoke-PipeScript -AttributeSyntaxTree $AttributedExpressionAst.Attribute
        } elseif ($currentInput -is [string]) {
            Invoke-PipeScript -AttributeSyntaxTree $AttributedExpressionAst.Attribute -ArgumentList $currentInput
        }
    }
    return
}

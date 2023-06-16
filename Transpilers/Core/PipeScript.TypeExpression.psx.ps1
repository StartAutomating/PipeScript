<#
.SYNOPSIS
    The PipeScript TypeExpression Transpiler 
.DESCRIPTION
    Type Expressions may be transpiled.
    
.Example
    {
        [include[a.ps1]]
    } | .>PipeScript
#>
[ValidateScript({
    $validating = $_
    if (-not $validating.TypeName) { return $false }
    $IsRealType = $TypeExpressionAst.TypeName.GetReflectionType()
    if ($IsRealType) { return $false }
    
    if ($TypeExpressionAst.TypeName.TypeName) {
        return $TypeExpressionAst.TypeName.TypeName.Name -ne 'ordered'
    } else {
        return $TypeExpressionAst.TypeName.Name -ne 'ordered'
    }    
})]
param(
# The attributed expression
[Parameter(Mandatory,ParameterSetName='AttributedExpressionAst',ValueFromPipeline)]
[Management.Automation.Language.TypeExpressionAst]
$TypeExpressionAst
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
    $IsRealType = $TypeExpressionAst.TypeName.GetReflectionType()
    if ($IsRealType) { return }

    $transpilerStepName  = 
        if ($TypeExpressionAst.TypeName.TypeName) {
            $TypeExpressionAst.TypeName.TypeName.Name
        } else {
            $TypeExpressionAst.TypeName.Name
        }
    
    if ($transpilerStepName -eq 'ordered') { return }

    $foundTranspiler =
        if ($currentInput -isnot [string]) {
            Get-Transpiler -CouldPipe $currentInput -TranspilerName "$transpilerStepName"
        } else {
            Get-Transpiler -TranspilerName "$transpilerStepName"
        }

    $argList = @()
    $parameters = @{}

    if ($TypeExpressionAst.TypeName.IsGeneric) {
        $TypeExpressionAst.TypeName.GenericArguments | 
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
        Invoke-PipeScript -CommandInfo $foundTranspiler  -ArgumentList $arglist -Parameter $parameters                                          
    } elseif ($foundTranspiler -and $currentInput -is [string]) {
        Invoke-PipeScript -CommandInfo $foundTranspiler -ArgumentList $arglist -Parameter $parameters
    } elseif ($script:TypeAcceleratorsList -notcontains $transpilerStepName -and $transpilerStepName -notin 'Ordered') {
        Write-Error "Unable to find a transpiler for [$TranspilerStepName]"
    }    
}

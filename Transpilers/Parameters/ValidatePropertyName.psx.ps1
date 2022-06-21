<#
.SYNOPSIS
    Validates Property Names
.DESCRIPTION
    Validates that an object has one or more property names.
.Example
    {
        param(
        [ValidatePropertyName(PropertyName='a','b')]
        $InputObject
        )
    } | .>PipeScript
.EXAMPLE
    [PSCustomObject]@{a='a';b='b'} |
        .> {
            param(
            [ValidatePropertyName(PropertyName='a','b')]
            [vfp]
            $InputObject
            )

            $InputObject
        }
.EXAMPLE
    @{a='a'} |
        .> {
            param(
            [ValidatePropertyName(PropertyName='a','b')]
            [vfp]
            $InputObject
            )

            $InputObject
        }
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
[Alias('ValidatePropertyNames')]
param(
# The property names being validated.
[Parameter(Mandatory,Position=0)]
[string[]]
$PropertyName,

# A variable expression.
# If this is provided, will apply a ```[ValidateScript({})]``` attribute to the variable, constraining future values.
[Parameter(ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {
    $checkPropertyNames = 
{        
    $foundProperties = @(
        foreach ($propName in $PropertyNames) {
            if ($inObject -is [Collections.IDictionary]) {
                $inObject.Contains($propName)
            } elseif ($inObject.psobject) {
                $null -ne $inObject.psobject.properties[$propName]
            } else {
                $false
            }
        }
    )
    $missingProperties = 
        @(
            for ($propertyIndex = 0; $propertyIndex -lt $propertyNames.Length; $propertyIndex++) {
            if (-not $foundProperties[$propertyIndex]) {
                $PropertyNames[$propertyIndex]
            }
        })
}

    
[ScriptBlock]::Create(@"
[ValidateScript({
    `$propertyNames = '$($PropertyName -join "','")'
    `$inObject = `$_
$checkPropertyNames
    if (`$MissingProperties) {
        throw "Missing Properties: `$(`$missingProperties -join ',')"
    }
    return `$true
})]
$(
    if ($psCmdlet.ParameterSetName -eq 'Parameter') {
        'param()'
    } else {
        '$' + $VariableAST.variablePath.ToString()
    }
)
"@)

}
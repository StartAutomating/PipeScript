<#
.Synopsis
    Validates if an object is one or more types.
.Description
    Validates if an object is one or more types.  
    
    This allows for a single parameter to handle multiple potential types.
.Example
    {
        param(
        [ValidateTypes(TypeName="ScriptBlock","string")]
        $In
        )
    } | .>PipeScript
.Example
    {"hello world"} |
        Invoke-PipeScript -ScriptBlock {
            param(
            [vfp()]
            [ValidateTypes(TypeName="ScriptBlock","string")]            
            $In
            )

            $In
        }
.Example
    1 | 
        Invoke-PipeScript -ScriptBlock {
            param(
            [vfp()]
            [ValidateTypes(TypeName="ScriptBlock","string")]            
            $In
            )

            $In
        }
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
param(
# The name of one or more types.
# Types can either be a .NET types of .PSTypenames
# TypeNames will be treated first as real types, then as exact matches, then as wildcards, and then as regular expressions.
[Parameter(Mandatory,Position=0,ValueFromRemainingArguments)]
[Alias('Type','Types','TypeNames','PSTypeName','PSTypeNames')]
[string[]]
$TypeName,

# The variable that will be validated.
[Parameter(ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

# Determine the list of real types at this point in time
$realTypes = 
    @(foreach ($tn in $typeName) {
        if ($tn -as [type]) {
            $tn -as [type]
        }
    })

# If all of the types are .NET types
if ($realTypes.Length -eq $TypeName.Length) {
    $checkTypes = @"
`$validTypeList = [$($realTypes -join '],[')]
"@ + {

$thisType = $_.GetType()
$IsTypeOk =
    $(@( foreach ($validType in $validTypeList) {
        if ($_ -as $validType) {
            $true;break
        }
    }))
}


} else {

    $checkTypes = @"
`$validTypeList = '$($typeName -join "','")'
"@ + {
$thisType = @(
    if ($_.GetType) {
        $_.GetType()
    }
    $_.PSTypenames
)
$IsTypeOk = 
    $(@(foreach ($validTypeName in $validTypeList) {
        $realType = $validTypeName -as [type]
        foreach ($Type in $thisType) {
            if ($Type -is [type]) {
                if ($realType) {
                    $realType -eq $type -or
                    $type.IsSubClassOf($realType) -or
                    ($realType.IsInterface -and $type.GetInterface($realType))
                } else {
                    $type.Name -eq $realType -or 
                    $type.Fullname -eq $realType -or 
                    $type.Fullname -like $realType -or $(
                        ($realType -as [regex]) -and 
                        $type.Name -match $realType -or $type.Fullname -match $realType
                    )
                }
            } else {
                $type -eq $realType -or 
                $type -like $realType -or (
                    ($realType -as [regex]) -and 
                    $type -match $realType
                )
            }
        }
    }) -eq $true) -as [bool]
}
}
if ($PSCmdlet.ParameterSetName -eq 'Parameter') {
[scriptblock]::Create(@"
[ValidateScript({
$checkTypes
if (-not `$isTypeOk) {
    throw "Unexpected type '`$(@(`$thisType)[0])'.  Must be '$($typeName -join "','")'."
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
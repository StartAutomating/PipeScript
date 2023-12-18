<#
.SYNOPSIS
    Dynamically Defines ValidateSet attributes
.DESCRIPTION
    Can Dynamically Define ValidateSet attributes.

    This is useful in circumstances where the valid set of values would be known at build, but would be tedious to write by hand.
.EXAMPLE
    {
        param(
        [ValidValues(Values={
           ([char]'a'..[char]'z')
        })]
        [string]
        $Drive
        )
    } | .>PipeScript
#>
[CmdletBinding(DefaultParameterSetName='ValueNames')]
[Alias('ValidValue')]
param(
# A list of valid values.
# To provide a dynamic list, provide a `[ScriptBlock]` value in the attribute.
[Parameter(Mandatory,ParameterSetName='ValueNames')]
[Alias('Value','ValidValue','ValidValues')]
[string[]]
$Values,

# If provided, will prefix each value
[string]
$Prefix,

# If provided, will add a suffix to each value
[string]
$Suffix,

# A VariableExpression.  
# If provided, this will be treated as the alias name or list of alias names.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {
    $validValueList = 
            @(foreach ($value in $Values) {
                "$(if ($Prefix) { $Prefix })$value$(if ($Suffix) { $Suffix })"            
            })
        
    if ($PSCmdlet.ParameterSetName -eq 'VariableExpressionAST') {
        [scriptblock]::Create("[ValidateSet('$($values -join "','")')]$VariableAST")
    } else {
        [scriptblock]::Create("[ValidateSet('$($values -join "','")')]param()")
    }
}


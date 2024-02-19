<#
.SYNOPSIS
    Dynamically Defines Aliases
.DESCRIPTION
    Can Dynamically Define Aliases.

    When uses in a parameter attribute, -Aliases will define a list of aliases.

    When used with a variable, [Aliases] will Set-Alias on each value in the variable.
.EXAMPLE
    {
        $aliases = "Foo", "Bar", "Baz"
        [Aliases(Command="Get-Process")]$aliases
    } | .>PipeScript
.Example
    {
        param(
        [Aliases(Aliases={
           ([char]'a'..[char]'z')
        })]
        [string]
        $Drive
        )
    } | .>PipeScript
#>
[CmdletBinding(DefaultParameterSetName='AliasNames')]
[Alias('SmartAlias','DynamicAlias')]
param(
# A list of aliases
[Parameter(Mandatory,ParameterSetName='AliasNames')]
[Alias('Alias')]
[string[]]
$Aliases,

# If provided, will prefix each alias
[string]
$Prefix,

# If provided, will add a suffix to each alias
[string]
$Suffix,

# The command being aliased.  This is only required when transpiling a variable.
[Parameter(Mandatory,ParameterSetName='VariableExpressionAST')]
[string]
$Command,

[Parameter(ParameterSetName='VariableExpressionAST')]
[switch]
$PassThru,

# A VariableExpression.  
# If provided, this will be treated as the alias name or list of alias names.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {
    if ($PSCmdlet.ParameterSetName -eq 'VariableExpressionAST') {
[ScriptBlock]::Create($({
@(foreach ($alias in @($aliasNames)) {
    Set-Alias "${Prefix}$alias${Suffix}" "$Command" -PassThru:$PassThru
})
} -replace '\${Prefix}', $Prefix -replace 
    '\${Suffix}', $Suffix -replace 
    '\$Command', $Command -replace 
    '\$AliasNames', "$variableAst" -replace
    '\$PassThru', ('$' + ($PassThru -as [bool]))
))
    } else {
        $aliasValues = 
            @(foreach ($alias in $aliasNames) {
                "$(if ($Prefix) { $Prefix })$alias$(if ($Suffix) { $Suffix })"            
            })
[scriptblock]::Create("[Alias('$($Aliases -join "','")')]param()")
    }
}


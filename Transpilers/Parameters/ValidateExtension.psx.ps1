<#
.SYNOPSIS
    Validates Extensions
.DESCRIPTION
    Validates that a parameter or object has one or more extensions.
    
    This creates a [ValidatePattern] that will ensure the extension matches.
.Example
    {        
        param(
        [ValidateExtension(Extension=".cs", ".ps1")]
        $FilePath
        )
    } |.>PipeScript
.Example
    .> {
        param(
        [ValidateExtension(Extension=".cs", ".ps1")]
        $FilePath
        )

        $FilePath
    } -Parameter @{FilePath=".ps1"}
.EXAMPLE
    .> {
        param(
        [ValidateExtension(Extension=".cs", ".ps1")]
        $FilePath
        )

        $FilePath
    } -Parameter @{FilePath="foo.txt"}
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
param(
# The extensions being validated.
[Parameter(Mandatory,Position=0)]
[string[]]
$Extension,

# A variable expression.
# If this is provided, will apply a ```[ValidatePattern({})]``` attribute to the variable, constraining future values.
[Parameter(ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

process {
    $validExtensionRegex = "\.(?>$($extension -replace '^\.' -join "|"))$"
[ScriptBlock]::Create(@"
[ValidatePattern('$($validExtensionRegex.Replace("'","''"))')]
$(
    if ($psCmdlet.ParameterSetName -eq 'Parameter') {
        'param()'
    } else {
        '$' + $VariableAST.variablePath.ToString()
    }
)
"@)
}
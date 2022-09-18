<#
.SYNOPSIS
    decorate transpiler
.DESCRIPTION
    Applies one or more typenames to an object.
    By 'decorating' the object with a typename, this enables use of the extended type system.
.EXAMPLE
    {
        $v = [PSCustomObject]@{}
        [decorate('MyTypeName',Clear,PassThru)]$v
    }.Transpile()
#>
[Alias('PSTypeName', 'Management.Automation.PSTypeName', 'System.Management.Automation.PSTypeName')]
param(
# The variable decoration will be applied to.
[Parameter(Mandatory,ParameterSetName='VariableAST', ValueFromPipeline)]
[Management.Automation.Language.VariableExpressionast]
$VariableAst,

# The TypeName(s) used to decorate the object.
[Parameter(Mandatory,Position=0)]
[Alias('PSTypeName')]
[string[]]
$TypeName,

# If set, will output the object after it has been decorated
[switch]
$PassThru,

# If set, will clear any underlying typenames.
[switch]
$Clear
)


process {
    if ($psCmdlet.ParameterSetName -eq 'VariableAST') {
        $variableText = $VariableAst.Extent.ToString()
        
        [ScriptBlock]::Create(
            @(
                if ($clear) {
                    $variableText + ".pstypenames.clear()"
                }
                foreach ($tn in $TypeName) {
                    $stn = $tn.Replace("'","''")
                    $variableText + ".pstypenames.add('$stn')"
                }
                if ($PassThru) {
                    $variableText
                }
            ) -join [Environment]::NewLine
        )
    }
}


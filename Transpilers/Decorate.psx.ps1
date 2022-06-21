[Alias('PSTypeName', 'Management.Automation.PSTypeName', 'System.Management.Automation.PSTypeName')]
[CmdletBinding(DefaultParameterSetName='ScriptBlock')]
param(
# The variable decoration will be applied to.
[Parameter(Mandatory=$true,ParameterSetName='VariableAST', ValueFromPipeline)]
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
                foreach ($tn in $PSTypeName) {
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


<#
.SYNOPSIS
    Validates the Platform    
.DESCRIPTION
    Validates the Platform.
    
    When used within Parameters, this adds a ```[ValidateScript({})]``` to ensure that the platform is correct.

    When used on a ```[Management.Automation.Language.VariableExpressionAst]``` will apply a 
    ```[ValidateScript({})]``` to that variable, which will prevent assignemnt to the variable if not on the platform.
.EXAMPLE
    {
        param(
        [ValidatePlatform("Windows")]
        [switch]
        $UseWMI
        )
    } | .>PipeScript
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
param(
# The name of one or more platforms.  These will be interpreted as wildcards.
[Parameter(Mandatory,Position=0)]
[string[]]
$Platform,

[Parameter(ValueFromPipeline,ParameterSetName='VariableExpressionAST')]
[Management.Automation.Language.VariableExpressionAST]
$VariableAST
)

$Platform = @($Platform -replace 'Windows', 'Win*')

$checkPlatform = @"
`$platformList = '$($Platform -join "','")'
"@ + {
$platformOK = ($platFormList -like 'Win*' -and $(
    $winPlat = @($platFormList -like 'Win*')[0]
    (-not $psVersionTable.Platform) -or $psVersionTable.Platform -like $winPlat
)) -or $(
    foreach ($platform in $platformList) {
        if ($psVersionTable.Platform -like $platform) {
            $true;break
        }
    }
)
}

if ($PSCmdlet.ParameterSetName -eq 'Parameter') {

    [ScriptBlock]::Create(@"
[ValidateScript({
`$ok = `$false
$checkPlatform
`$ok = `$platformOK
if (-not `$ok) {
    throw "Incorrect Platform: '`$(`$psVersionTable.Platform)'.  Must be like '$($Platform -join "','")'."
}
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
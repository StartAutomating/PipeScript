<#
.SYNOPSIS
    ValueFromPipline Shorthand
.DESCRIPTION
      This is syntax shorthand to create [Parameter] attributes that take ValueFromPipelineByPropertyName.
#>
[Alias('VFPBPN')]
param(
[Alias('ParameterSetName')]
[string]
$ParameterSet,

[switch]
$Mandatory,

[Alias('VFP')]
[switch]
$ValueFromPipeline
)

$paramOptions = @(    
    if ($Mandatory) {
        "Mandatory"
    }
    if ($ParameterSet) {
        "ParameterSetName='$($ParameterSet.Replace("'","''"))'"
    }
    "ValueFromPipelineByPropertyName"
    if ($ValueFromPipeline) {
        "ValueFromPipeline"
    }
    if ($PSBoundParameters.ContainsKey('Position')) {
        "Position=$position"
    }
) -join ','

$nsb = [ScriptBlock]::Create(
"[Parameter($paramOptions)]param()"
)

$nsb
<#
.SYNOPSIS
    ValueFromPiplineByPropertyName Shorthand
.DESCRIPTION
    This is syntax shorthand to create [Parameter] attributes that take ValueFromPipelineByPropertyName.
#>
[Alias('VFPBPN')]
param(
# The name of the parameter set
[Alias('ParameterSetName')]
[string]
$ParameterSet,

# If set, the parameter will be Mandatory.
[switch]
$Mandatory,

# If set, the parameter will also take value from Pipeline
[Alias('VFP')]
[switch]
$ValueFromPipeline,

# The position of the parameter.
[int]
$Position
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
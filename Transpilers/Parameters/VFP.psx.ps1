<#
.SYNOPSIS
    ValueFromPipline Shorthand
.DESCRIPTION
    This is syntax shorthand to create [Parameter] attributes that take ValueFromPipeline.
#>
param(
# The parameter set name.
[Alias('ParameterSetName')]
[string]
$ParameterSet,

# If set, will mark this parameter as mandatory (within this parameter set).
[switch]
$Mandatory,

# If set, will also mark this parameter as taking ValueFromPipelineByPropertyName.
[Alias('VFPBPN', 'VBN')]
[switch]
$ValueFromPipelineByPropertyName,

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
    if ($PSBoundParameters.ContainsKey('Position')) {
        "Position=$position"
    }

    "ValueFromPipeline"
    if ($ValueFromPipelineByPropertyName) {
        "ValueFromPipelineByPropertyName"
    }
) -join ','

[ScriptBlock]::Create(
"[Parameter($paramOptions)]param()"
)

$nsb
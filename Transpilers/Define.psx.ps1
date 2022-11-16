<#
.SYNOPSIS
    defines a variable
.DESCRIPTION
    Defines a variable using a value provided during a build
.EXAMPLE
    {
        [Define(Value={Get-Random})]$RandomNumber
    }.Transpile()
.EXAMPLE
    {
        [Define(Value={$global:ThisValueExistsAtBuildTime})]$MyVariable
    }.Transpile()
#>
param(
# The value to define.
# When this value is provided within an attribute as a ScriptBlock, the ScriptBlock will be run at build time.
[Parameter(Mandatory)]
[AllowNull()]
[PSObject]
$Value,

# The variable the definition will be applied to.
[Parameter(Mandatory,ParameterSetName='VariableAST', ValueFromPipeline)]
[Management.Automation.Language.VariableExpressionast]
$VariableAst,

# A scriptblock the definition will be applied to
[Parameter(Mandatory,ParameterSetName='ScriptBlock', ValueFromPipeline)]
[scriptblock]
$ScriptBlock = {},

# The name of the variable.  If define is applied as an attribute of a variable, this does not need to be provided.
[Alias('Name')]
[string]
$VariableName
)

begin {
    function EmbedString {
        param($str) {
            if ($val.Contains('$')) {
                if ($val -match '[\r\n]') {
                    '"@' + [Environment]::NewLine + $val.Replace('"', '`"') + [Environment]::NewLine + '@"'
                } else {
                    '"' + $val.Replace('"', '`"') + '"'
                }
            } else {
                if ($val -match '[\r\n]') {
                    "'@" + [Environment]::NewLine + $val.Replace("'", "''") + [Environment]::NewLine + "@'"
                } else {
                    "'" + $val.Replace("'", "''") + "'"
                }
            }        
        }
    }
}

process {
    # Get the value we want to define
    $definedValue = 
        # A null will become 
        if ($value -eq $null) {
            '$null' # $null
        }
        # a string
        elseif ($value -is [string]) {
            EmbedString $value # will be embedded
        }
        # a boolean        
        elseif ($value -is [bool]) {
            if ($value) {
                '$true' # will become $true
            }
            else {
                '$false' # or $false
            }
        }
        # a primitive
        elseif ($value.GetType().IsPrimitive) {
            # will be embedded and typecast
            "[$($value.GetType().Name)]$value"
        }
        # a [ScriptBlock]
        elseif ($value -is [ScriptBlock]) {
            "{$value}" # will be embedded within {}
        }
        # a [timespan]
        elseif ($value -is [Timespan]) {
            # can be cast from it's stringified value
            "[Timespan]'$value'"
        }
        # a [DateTime]
        elseif ($value -is [DateTime]) {
            # can be cast from a standardized string value
            "[DateTime]'$($value.ToString('o'))'"
        }
        # Otherwise,
        else {
            # embed the variable as JSON
            "@'
$($value | ConvertTo-Json -Depth 100)
'@ | ConvertFrom-Json"
        }

    if ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
        if (-not $VariableName) {
            Write-Error "Must provide a -VariableName"
            return
        }
    }


    if ($PSCmdlet.ParameterSetName -eq 'VariableAst') {
        [ScriptBlock]::Create('$' + $VariableAst.VariablePath.ToString() + ' = ' + $definedValue)
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
        $blockName  =
            if ($ScriptBlock.Ast.DynamicParamBlock) {
                "dynamicParam"
            } elseif ($scriptblock.Ast.beignBlock.Statements) {
                "begin"
            } elseif ($scriptBlock.Ast.processblock.Statements) {
                "process"
            } else {
                ""   
            }
        if ($blockName) {
            [ScriptBlock]::Create("$blockName {'$' + $VariableName + ' = ' + $definedValue}"), $ScriptBlock | Join-PipeScript
        }
        else {
            [ScriptBlock]::Create('$' + $VariableName + ' = ' + $definedValue), $ScriptBlock | Join-PipeScript
        }        
    }
}
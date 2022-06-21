<#
.SYNOPSIS
    Help Transpiler
.DESCRIPTION
    The Help Transpiler allows you to write inline help without directly writing comments.
.EXAMPLE
    {
        [Help(Synopsis="The Synopsis", Description="A Description")]
        param()

        
        "This Script Has Help, Without Directly Writing Comments"
        
    } | .>PipeScript
.Example
    {
        param(
        [Help(Synopsis="X Value")]
        $x
        )
    } | .>PipeScript
.EXAMPLE
    {
        param(
        [Help("X Value")]
        $x
        )
    } | .>PipeScript
#>
[CmdletBinding(DefaultParameterSetName='Parameter')]
param(
[Parameter(Mandatory,Position=0)]
[string]
$Synopsis,

[string]
$Description,

[string[]]
$Example,

[string[]]
$Link,

[Parameter(ValueFromPipeline,ParameterSetName='ScriptBlock')]
[scriptblock]
$ScriptBlock
)

process {
    if ($PSCmdlet.ParameterSetName -eq 'Parameter') {
        [ScriptBlock]::Create('' + $(
        if ($Synopsis -match '[\r\n]') {
            if ($Synopsis -notmatch '#\>') {
                "<#" + [Environment]::newLine + $Synopsis + [Environment]::newLine + "#>"
            } else {
                $Synopsis -split "[\r\n]{1,}" -replace '^', '# '
            }
        } else {
            "# $Synopsis"
        }
        ) + 'param()')
    } elseif ($psCmdlet.ParameterSetName -eq 'ScriptBlock') {
        $helpScriptBlock = [ScriptBlock]::Create('<#' + [Environment]::NewLine + $(@(
        '.Synopsis'
        $Synopsis -split "[\r\n]{1,}" -replace '^', '    '
        if ($Description) {
            '.Description'
            $Description -split "[\r\n]{1,}" -replace '^', '    '
        }
        foreach ($ex in $Example) {
            '.Example'
            $ex -split "[\r\n]{1,}" -replace '^', '    '
        }
        foreach ($lnk in $Link) {
            '.Link'
            $lnk -split "[\r\n]{1,}" -replace '^', '    '
        }
        ) -join [Environment]::newLine) + [Environment]::newLine + "#>
        param()
        ")

        $helpScriptBlock, $scriptBlock | Join-PipeScript
    }   
}
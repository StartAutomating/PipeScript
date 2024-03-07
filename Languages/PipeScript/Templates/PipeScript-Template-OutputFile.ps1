[ValidatePattern("PipeScript")]
param()


function Template.PipeScript.OutputFile {

    <#
    .SYNOPSIS
        Outputs to a File
    .DESCRIPTION
        Outputs the result of a script into a file.
    .EXAMPLE
        Invoke-PipeScript {
            [OutputFile("hello.txt")]
            param()

            'hello world'
        }
    .Example
        Invoke-PipeScript {
            param()

            $Message = 'hello world'
            [Save(".\Hello.txt")]$Message
        }
    #>
    [Alias('Save','OutputFile')]
    param(
    # The Output Path
    [Parameter(Mandatory)]
    [string]
    $OutputPath,

    # The Script Block that will be run.
    [Parameter(ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock,

    [Parameter(ValueFromPipeline)]
    [Management.Automation.Language.VariableExpressionast]
    $VariableAst,

    # The encoding parameter.
    [string]
    $Encoding,

    # If set, will force output, overwriting existing files.
    [switch]
    $Force,

    # The export script
    [scriptblock]
    $ExportScript,

    # The serialization depth.  Currently only used when saving to JSON files.
    [int]
    $Depth = 100
    )

    begin {
        function SaveJson {
            # Determine if the content appears to already be JSON
            if ($jsonToSave -match '^[\s\r\n]{0,}[\[\{\`"/]') {
                $jsonToSave | Set-Content -Path '$safeOutputPath' $OtherParams
            } else {
                ConvertTo-JSON -InputObject `$jsonToSave -Depth $depth |
                    Set-Content -Path '$safeOutputPath' $otherParams
            }
        }
    }

    process {
        $safeOutputPath = $OutputPath.Replace("'","''")
        $otherParams = @(
            if ($Encoding) {
                "-Encoding '$($encoding.Replace("'", "''"))'"
            }
            if ($Force) {
                "-Force"
            }
        ) -join ' '

        $inputObjectScript = 
            if ($VariableAst) {
                $VariableAst.Extent.ToString()
            } elseif ($ScriptBlock.Ast.ParamBlock.Parameters.Count)
            {
                "`$ParameterCopy = [Ordered]@{} + `$psBoundParameters; & { $ScriptBlock } @ParameterCopy"
            } else {
                "& { $ScriptBlock }"
            }
    
        if ($OutputPath -match '\.json') {
            [ScriptBlock]::Create("
`$jsonToSave = $inputObjectScript
# Determine if the content appears to already be JSON
if (`$jsonToSave -match '^[\s\r\n]{0,}[\[\{\`"/]') {
    `$jsonToSave | Set-Content -Path '$safeOutputPath' $OtherParams
} else {
    ConvertTo-JSON -InputObject `$jsonToSave -Depth $depth | Set-Content -Path '$safeOutputPath' $otherParams
}

    ")
        }
        elseif ($OutputPath -match '\.[c|t]sv$') {
            [ScriptBlock]::Create("$inputObjectScript | Export-Csv -Path '$safeOutputPath' $otherParams")
        }
        elseif ($OutputPath -match '\.(?>clixml|clix|xml)$') {
            [ScriptBlock]::Create("
`$toSave = $inputObjectScript
if (`$toSave -as [xml]) {
    `$strWrite = [IO.StringWriter]::new()
    `$configurationXml.Save(`$strWrite)
    (`"$strWrite`" -replace '^\<\?xml version=`"1.0`" encoding=`"utf-16`"\?\>') | Set-Content -Path '$safeOutputPath' $otherParams
} else {
    `$toSave | Export-Clixml -Path '$safeOutputPath' $otherParams
}
")
        }
        else {
            [ScriptBlock]::Create("$inputObjectScript | Set-Content -Path '$safeOutputPath' $otherParams")
        }
    }


}


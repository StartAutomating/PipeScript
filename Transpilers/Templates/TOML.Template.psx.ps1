<#
.SYNOPSIS
    TOML Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate TOML.

    Because TOML does not support comment blocks, PipeScript can be written inline inside of specialized Multiline string

    PipeScript can be included in a TOML string that starts and ends with ```{}```, for example ```"""{}"""```
.Example
    .> {
        $tomlContent = @'
[seed]
RandomNumber = """{Get-Random}"""
'@
        [OutputFile('.\RandomExample.ps1.toml')]$tomlContent
    }

    .> .\RandomExample.ps1.toml
#>
[ValidatePattern('\.toml$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.CommandInfo]
$CommandInfo,

# A dictionary of parameters.
[Collections.IDictionary]
$Parameter,

# A list of arguments.
[PSObject[]]
$ArgumentList
)

begin {
    # We start off by declaring a number of regular expressions:
    
    $startComment = '(?>"""\{)'
    $endComment   = '(?>\}""")'
    
    $startRegex = "(?<PSStart>${startComment})"    
    $endRegex   = "(?<PSEnd>${endComment})"
    
    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
    }
}

process {
    # Add parameters related to the file
    $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
    $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
}

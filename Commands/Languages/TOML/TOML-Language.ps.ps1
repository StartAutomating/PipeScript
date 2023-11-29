Language function TOML {
<#
.SYNOPSIS
    TOML PipeScript Language Definition.
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
param()
    $FilePattern = '\.toml$'
    # We start off by declaring a number of regular expressions:
    
    $startComment = '(?>"""\{)'
    $endComment   = '(?>\}""")'
    
    $startPattern = "(?<PSStart>${startComment})"    
    $endPattern   = "(?<PSEnd>${endComment})"

    # TOML is a DataLanguage
    $IsDataLanguage = $true
}

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
    # TOML files end in `.toml`
    $FilePattern = '\.toml$'

    # We start off by declaring a number of regular expressions:
    # TOML doesn't have comments per se, but it has literal string blocks `"""`
    $startComment = '(?>""")'
    $endComment   = '(?>""")'
    
    $startPattern = "(?<PSStart>${startComment}\{\s{0,})"    
    $endPattern   = "(?<PSEnd>\s{0,}\}${endComment})"

    # TOML is a DataLanguage
    $DataLanguage = $true
    # and it is always case-sensitive.
    $CaseSensitive = $true
}

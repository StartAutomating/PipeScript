<#
.SYNOPSIS
    Bicep Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Bicep with Inline PipeScript into Bicep.

    Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    * ```''```
    * ```{}```
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.bicep$') {
        return $true
    }
    return $false
})]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
$CommandInfo
)

begin {
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext 
    $IgnoredContext = "(?<ignore>(?>$("''", "\{\}" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    $sourcePattern  = [Regex]::New("(?>$(
        $startRegex, $endRegex -join ([Environment]::NewLine + '|' + [Environment]::NewLine)
    ))", "IgnoreCase, IgnorePatternWhitespace", "00:00:05")
}

process {
    
    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -SourcePattern $sourcePattern
}
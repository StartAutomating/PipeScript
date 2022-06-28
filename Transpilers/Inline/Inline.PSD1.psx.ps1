<#
.SYNOPSIS
    PSD1 Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles PSD1 with Inline PipeScript into PSD1.

    Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.

    Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.

    * ```''```
    * ```{}```
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.psd1$') {
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
    $startComment = '<\#' # * Start Comments ```\*```
    $endComment   = '\#>' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext (single-quoted strings)
    $IgnoredContext = "
    (?<ignore>
        (?>'((?:''|[^'])*)')
        [\s - [ \r\n ] ]{0,}
    ){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = [Regex]::New("(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)", 'IgnorePatternWhitespace')
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment}[\s-[\r\n]]{0,}${IgnoredContext})"
}

process {
    
    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -StartPattern $startRegex -EndPattern $endRegex
}
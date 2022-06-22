<#
.SYNOPSIS
    Razor Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Razor with Inline PipeScript into Razor.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

    Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.(cshtml|razor)$') {
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
    $startComment = '(?><\!--|/\*|\@\*)' 
    $endComment   = '(?>-->|\*/|\*@)'
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $sourcePattern  = [Regex]::New("(?>$(
        $startRegex, $endRegex -join ([Environment]::NewLine + '|' + [Environment]::NewLine)
    ))", "IgnoreCase, IgnorePatternWhitespace", "00:00:05")
}

process {
    
    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -SourcePattern $sourcePattern
}
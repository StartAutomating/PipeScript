<#
.SYNOPSIS
    Perl Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Perl with Inline PipeScript into Perl.

    Also Transpiles Plain Old Document

    PipeScript can be embedded in a Plain Old Document block that starts with ```=begin PipeScript``` and ends with ```=end PipeScript```.    
.EXAMPLE
    .> {
        $HelloWorldPerl = @'
=begin PipeScript
$msg = "hello", "hi", "hey", "howdy" | Get-Random
"print(" + '"' + $msg + '");'
=end   PipeScript
'@

        [Save(".\HelloWorld.ps1.pl")]$HelloWorldPerl
    }

    .> .\HelloWorld.ps1.pl
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.(?>pl|pod)$') {
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
    
    $startComment = '(?>
        (?>^|\[\r\n]{1,2})\s{0,}
        =begin
        \s{1,}
        (?>Pipescript|\{)
        [\s\r\n\{]{0,}
    )'
    $endComment   = '(?>
        [\r\n]{1,3}
        \s{0,}
        =end
        (?>\}|\s{1,}PipeScript[\s\r\n\}]{0,})
    )'
    
    $startRegex = "(?<PSStart>${startComment})"    
    $endRegex   = "(?<PSEnd>${endComment})"

    $sourcePattern  = [Regex]::New("(?>$(
        $startRegex, $endRegex -join ([Environment]::NewLine + '|' + [Environment]::NewLine)
    ))", "IgnoreCase, IgnorePatternWhitespace", "00:00:05")
}

process {
    
    $fileInfo = $commandInfo.Source -as [IO.FileInfo]
    $fileText      = [IO.File]::ReadAllText($fileInfo.Fullname)

    .>PipeScript.Inline -SourceFile $CommandInfo.Source -SourceText $fileText -SourcePattern $sourcePattern
}

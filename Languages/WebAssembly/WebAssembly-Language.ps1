[ValidatePattern("(?>WebAssembly|Language)[\s\p{P}]")]
param()


function Language.WebAssembly {
<#
.SYNOPSIS
    WebAssembly PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate WebAssembly.    

    Multiline comments blocks like this ```(;{

    };)``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.wat$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern = '\.wat$'
    # We start off by declaring a number of regular expressions:
    $startComment = '\(\;' # * Start Comments ```(;```
    $endComment   = '\;\)'   # * End Comments   ```;)```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    $LanguageName = 'WebAssembly'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.WebAssembly")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



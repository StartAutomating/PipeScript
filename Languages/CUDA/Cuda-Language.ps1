[ValidatePattern("(?>Cuda|Language)[\s\p{P}]")]
param()


function Language.Cuda {
<#
    .SYNOPSIS
        Cuda PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Cuda.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.    

        The Cuda Inline PipeScript Transpiler will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.cu$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # Cuda files are named `.cu`.
    $FilePattern = '\.cu$'    

    # Cuda is case sensitive.
    $CaseSensitive = $true

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    # Cuda's compiler is "nvcc" (if found)
    $Compiler = 'nvcc'
    $LanguageName = 'Cuda'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Cuda")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


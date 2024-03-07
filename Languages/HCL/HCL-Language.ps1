[ValidatePattern("(?>HCL|Language)[\s\p{P}]")]
param()



function Language.HCL {
<#
    .SYNOPSIS
        HCL PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate HCL (Hashicorp Commmand Language).

        Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        * ```null```
        * ```""```
        * ```{}```
        * ```[]```
    #>
[ValidatePattern('\.hcl$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
    )

    $FilePattern = '\.hcl$'
    
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "\{\}", "\[\]" -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    $LanguageName = 'HCL'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.HCL")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


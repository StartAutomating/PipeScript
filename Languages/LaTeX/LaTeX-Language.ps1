[ValidatePattern("(?>Latex|Language)[\s\p{P}]")]
param()


function Language.LaTeX {
<#
    .SYNOPSIS
        LaTeX PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Latex and Tex files.

        Multiline comments with %{}% will be treated as blocks of PipeScript.    
    #>
[ValidatePattern('\.(?>latex|tex)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    
    $FilePattern = '\.(?>latex|tex)$'

    # We start off by declaring a number of regular expressions:
    $startComment = '\%\{' # * Start Comments ```%{```
    $endComment   = '\}\%' # * End Comments   ```}%```
    $Whitespace   = '[\s\n\r]{0,}'        
    $StartPattern = "(?<PSStart>${startComment})"    
    $EndPattern   = "(?<PSEnd>${endComment}\s{0,})"
    $LanguageName = 'LaTeX'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.LaTeX")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


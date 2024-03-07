[ValidatePattern("(?>ATOM|Language)")]
param()


function Language.ATOM {
<#
    .SYNOPSIS
        ATOM Language Definition
    .DESCRIPTION
        Defines ATOM within PipeScript.

        This allows ATOM to be templated.
        
        Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
    #>
[ValidatePattern('\.atom$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # Atom files end in `.atom`

    $FilePattern = '\.atom$'

    # Atom comments are HTML/XML style tags
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    
    # PipeScript code can be embedded within a comment block that has a scriptblock
    # <!--{<# Your Code Goes Here #>}-->
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    # ATOM is a data language
    $DataLanguage = $true
    # and it is case-sensitive.
    $CaseSentitive = $true

    $Interpreter = {        
        $xmlFiles = @(foreach ($arg in $args) {
            if (Test-path $arg) {                
                [IO.File]::ReadAllText($arg) -as [xml]
            }
            else {
                $otherArgs += $arg
            }
        })
        
        $xmlFiles
    }
    $LanguageName = 'ATOM'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.ATOM")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


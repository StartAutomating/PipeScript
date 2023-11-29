
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

    # We start off by declaring a number of regular expressions:
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $IsDataLanguage = $true

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


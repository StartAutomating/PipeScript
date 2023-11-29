
function Language.PHP {
<#
.SYNOPSIS
    PHP Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate PHP.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS/PHP comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.php$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    # PHP's file pattern is simply ".php"
    $FilePattern = '\.php$'
    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*)' # * Start Comments ```<!--```
    $endComment   = '(?>-->|\*/)'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    # If the application PHP is in the path, we'll use it as the interpreter.
    $Interpreter = $ExecutionContext.SessionState.InvokeCommand.GetCommand('php','Application')
    $LanguageName = 'PHP'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.PHP")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



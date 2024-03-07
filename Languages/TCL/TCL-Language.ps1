[ValidatePattern("(?>TCL|TK|Language)[\s\p{P}]")]
param()


function Language.TCL {
<#
.SYNOPSIS
    TCL/TK PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate TCL or TK.

    Because TCL Scripts only allow single-line comments, this is done using a pair of comment markers.

    # { or # PipeScript{  begins a PipeScript block

    # } or # }PipeScript  ends a PipeScript block

    ~~~tcl    
    # {

    Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "puts `"$message`""

    # }
    ~~~
.EXAMPLE
    Invoke-PipeScript {
        $tclScript = '    
    # {

    # # Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "puts `"$message`""

    # }
    '
    
        [OutputFile('.\HelloWorld.ps1.tcl')]$tclScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.tcl
#>
[ValidatePattern('\.t(?>cl|k)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern = '\.t(?>cl|k)$'
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>\#\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>\#\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'        
    $startPattern = "(?<PSStart>${startComment})"
    $endPattern   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    # Using -LinePattern will skip any inline code not starting with #
    $LinePattern   = "^\s{0,}\#\s{0,}"
    $LanguageName = 'TCL'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.TCL")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}




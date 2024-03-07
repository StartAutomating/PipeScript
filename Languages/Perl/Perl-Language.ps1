[ValidatePattern("(?>Perl|Language)[\s\p{P}]")]
param()



function Language.Perl {
<#
.SYNOPSIS
    Perl Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Perl.

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
[ValidatePattern('\.(?>pl|pod)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    # Perl files are either .pl or .pod
    $FilePattern = '\.(?>pl|pod)$'
        
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
    
    $startPattern = "(?<PSStart>${startComment})"    
    $endPattern   = "(?<PSEnd>${endComment})"

    # If Perl is in the Path, we'll use it as the interpreter.
    $Interpreter = $ExecutionContext.SessionState.InvokeCommand.GetCommand('perl','Application')
    $LanguageName = 'Perl'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Perl")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



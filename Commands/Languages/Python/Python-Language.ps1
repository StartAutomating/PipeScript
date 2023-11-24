
function Language.Python {
<#
.SYNOPSIS
    Python Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Python.
    Because Python does not support multiline comment blocks, PipeScript can be written inline inside of multiline string
    PipeScript can be included in a Python string that starts and ends with ```{}```, for example ```"""{}"""```
.Example
    .> {
       $pythonContent = @'
"""{
$msg = "Hello World", "Hey There", "Howdy" | Get-Random
@"
print("$msg")
"@
}"""
'@
        [OutputFile('.\HelloWorld.ps1.py')]$PythonContent
    }
    .> .\HelloWorld.ps1.py
.EXAMPLE
    'print("Hello World")' > .\HelloWorld.py
    Invoke-PipeScript .\HelloWorld.py # Should -Be 'Hello World'
#>
[ValidatePattern('\.py$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Python'
    
    # We start off by declaring a number of regular expressions:
    
    $startComment = '(?>"""\{)'
    $endComment   = '(?>\}""")'
    
    $startPattern = "(?<PSStart>${startComment})"    
    $endPattern   = "(?<PSEnd>${endComment})"
    $Interpreter  = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('python', 'Application'))[0]
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Python")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


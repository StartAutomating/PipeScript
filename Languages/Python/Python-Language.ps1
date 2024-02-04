
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
    param()
    # The File Pattern for Python is any `.py` files.
    $FilePattern = '\.py$'
    
    # Python doesn't have multi-line comments per se, but it does have ignored block strings.
    # So any `"""{` will start a block    
    $startComment = '(?>"""\{)'
    # and any `}###` will end a block.
    $endComment   = '(?>\}""")'
    
    $startPattern = "(?<PSStart>${startComment})"    
    $endPattern   = "(?<PSEnd>${endComment})"

    # The interpreter for Python is "python" (if present)
    $Interpreter  = 'python'

    # The keywords map for Python is as follows:

    $Keywords = [PSCustomObject][Ordered]@{
                        "def"       = 'function ($Parameters)
                    $Body
                '
                        "class"     = 'class ${Name}:
                    $Members
                '
                        "if"        = 'if'
                        "elseif"    = "elif"
                        "else"      = "else"
                        "for"       = "foreach", "for"
                        "raise"     = "throw"
                        "break"     = "break"
                        "continue"  = "continue"
                        "not"       = "-not"
                        "or"        = "-or"
                        "and"       = "-and"
                        "nonlocal"  = '`$global:$VariablePath'
                        "True"      = $true
                        "False"     = $false
                        "while"     = "while"
                        "yield"     = ""
                        "import"    = "import"
                    }
    $LanguageName = 'Python'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Python")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


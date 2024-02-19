Language function Python {
<#
.SYNOPSIS
    Python Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Python.

    Because Python does not support multiline comment blocks, PipeScript can be written inline inside of multiline string

    PipeScript can be included in a Python string that starts and ends with ```{}```, for example ```"""{}"""```
.EXAMPLE
    'print("Hello World")' > .\HelloWorld.py
    Invoke-PipeScript .\HelloWorld.py
.EXAMPLE
    Template.HelloWorld.py -Message "Hi" | Set-Content ".\Hi.py"
    Invoke-PipeScript .\Hi.py
#>
[ValidatePattern('\.py$')]
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

    $Keywords = Object @{
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
}
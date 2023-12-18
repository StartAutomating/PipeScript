Language function JavaScript {
<#
.SYNOPSIS
    JavaScript PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate JavaScript.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    String output from these blocks will be embedded directly.  All other output will be converted to JSON.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    The JavaScript Inline Transpiler will consider the following syntax to be empty:

    * ```undefined```
    * ```null```
    * ```""```
    * ```''```
.EXAMPLE
    Invoke-PipeScript {
        Hello.js template '
        msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
        if (console) {
            console.log(msg);
        }
        '
        
    }
.EXAMPLE
    Invoke-PipeScript {
        $helloMsg = {param($msg = 'hello world') "`"$msg`""}
        $helloJs = HelloWorld.js template "
        msg = null /*{$helloMsg}*/;
        if (console) {
            console.log(msg);
        }
        "
        $helloJs
    }
.EXAMPLE
    "console.log('hi')" > .\Hello.js
    Invoke-PipeScript .\Hello.js
#>
[ValidatePattern('\.js$')]
param(
)
    # JavaScript's file Pattern is `\.js$` or `.mjs$`
    $FilePattern = '\.m?js$'

    # and JavaScript is a case sensitive language.
    $CaseSensitive = $true

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("undefined", "null", '""', "''" -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    $Interpreter  = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('node', 'Application'))[0] # Get the first node, if present

    $ForeachObject = {
        $in = $_
        if (($in -is [string]) -or 
            ($in -ne $null -and $in.GetType().IsPrimitive)) {
            "$in"
        } else {
            "$(ConvertTo-Json -Depth 100 -InputObject $in)"
        }
    }   
}
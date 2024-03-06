[ValidatePattern("(?>Go|Language)[\s\p{P}]")]
param()

Language function Go {
    <#
    .SYNOPSIS
        Go Template Transpiler.
    .DESCRIPTION
        Allows PipeScript to Generate Go.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        This for Inline PipeScript to be used with operators, and still be valid Go syntax. 

        The Go Transpiler will consider the following syntax to be empty:

        * ```nil```
        * ```""```
        * ```''```
    .EXAMPLE
        Invoke-PipeScript {    
            HelloWorld.go template '
        package main

        import "fmt"
        func main() {
            fmt.Println("/*{param($msg = "hello world") "`"$msg`""}*/")
        }
        '
        }
    .EXAMPLE
        Invoke-PipeScript {
        $HelloWorld = {param([Alias('msg')]$message = "Hello world") "`"$message`""}
        $helloGo = HelloWorld.go template "
        package main

        import `"fmt`"
        func main() {
            fmt.Println(`"/*{$helloWorld}*/`")
        }
        "

        $helloGo.Save()
        }
    .EXAMPLE
        '
        package main
        import "fmt"
        func main() {
            fmt.Println("hello world")
        }
        ' | Set-Content .\HelloWorld.go

        Invoke-PipeScript .\HelloWorld.go
    #>
    [ValidatePattern('\.go$')]
    param(
    )

    $FilePattern = '\.go$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("nil", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    # Find Go in the path
    $GoApplication = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('go', 'Application'))[0]

    $Compiler = # To compile go
        $GoApplication, # we call 'go'
        'build' # followed by 'build'
    
    $Interpreter  = # To interpret go,
        $GoApplication, # we call 'go' in the path
        'run' # and always pass it run.
        # (despite the name, this is an interpreter, not a runner, because it is passed the go file path)
    
}

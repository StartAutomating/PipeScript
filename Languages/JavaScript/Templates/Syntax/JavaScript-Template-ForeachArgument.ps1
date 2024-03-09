
function Template.ForeachArgument.js {

    <#
    .SYNOPSIS
        JavaScript Foreach Argument Template
    .DESCRIPTION
        A Template for a script that walks over each argument, in JavaScript.    
    .EXAMPLE
        Template.ForeachArgument.js | Set-Content .\Args.js
        Invoke-PipeScript -Path .\Args.js -Arguments "a",@{"b"='c'}
    #>
    [Alias('Template.JavaScript.ForeachArgument')]
    param(
    # One or more statements
    # By default this is `print(sys.argv[i])`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Body','Code','Block','Script','Scripts')]
    [string[]]
    $Statement = "console.log(args[arg])",

    # One or more statements to run before the loop.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Before = 'let args = []',

    # The statement to run after the loop.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $After,

    # The source of the arguments.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ArgumentSource = 'process.argv.slice(2).forEach(arg => args.push(arg))',

    # The current argument variable.
    # This initializes the loop.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CurrentArgument','ArgumentVariable')]    
    [string]
    $Variable = 'arg',

    # The argument collection.
    # This is what is looped thru.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Condition = 'args',    

    # The number of characters to indent.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateRange(1,10)]    
    [int]
    $Indent = 2
    )
    process {
@"
$($Before -join [Environment]::newLine)
$ArgumentSource
$(
    Template.ForEachLoop.js -Variable $Variable -Condition $Condition -Body ($Statement -join [Environment]::newLine)
)$(
if ($after) {
    [Environment]::NewLine + ($After -join [Environment]::newLine)
}
)
"@
    }

}



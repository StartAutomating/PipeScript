Template function ForeachArgument.js {
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
    [vbn()]
    [Alias('Body','Code','Block','Script','Scripts')]
    [string[]]
    $Statement = "console.log(args[arg])",

    # One or more statements to run before the loop.    
    [vbn()]
    [string[]]
    $Before = 'let args = []',

    # The statement to run after the loop.    
    [vbn()]
    [string[]]
    $After,

    # The source of the arguments.    
    [vbn()]
    [string]
    $ArgumentSource = 'process.argv.slice(2).forEach(arg => args.push(arg))',

    # The current argument variable.
    # This initializes the loop.
    [vbn()]
    [Alias('CurrentArgument','ArgumentVariable')]    
    [string]
    $Variable = 'arg',

    # The argument collection.
    # This is what is looped thru.
    [vbn()]
    [string]
    $Condition = 'args',    

    # The number of characters to indent.
    [vbn()]
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

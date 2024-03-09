
function Template.ForeachArgument.py {

    <#
    .SYNOPSIS
        Python Foreach Argument Template
    .DESCRIPTION
        A Template that walks over each argument, in Python.    
    .EXAMPLE
        Template.ForeachArgument.py | Set-Content .\Args.py
        Invoke-PipeScript -Path .\Args.py -Arguments "a",@{"b"='c'}
    #>
    [Alias('Template.Python.ForeachArgument')]
    param(
    # One or more statements
    # By default this is `print(sys.argv[i])`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Body','Code','Block','Script','Scripts')]
    [string[]]
    $Statement = "print(sys.argv[i])",

    # One or more statements to run before the loop.
    # By default this is `import sys`.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Before = "import sys",

    # The statement to run after the loop.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $After,

    # The source of the arguments.
    # By default this is `for i in range(1, len(sys.argv)):`
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ArgumentSource = 'for i in range(1, len(sys.argv)):',    

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
    '' + (' ' * $Indent) + $(
        $Statement -join ([Environment]::NewLine)
    )
)$(
if ($after) {
    [Environment]::NewLine + ($After -join [Environment]::newLine)
}
)
"@
    }

}



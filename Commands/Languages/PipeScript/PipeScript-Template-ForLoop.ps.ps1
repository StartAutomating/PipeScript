Template function PipeScript.For {
    <#
    .SYNOPSIS
        Template for a PipeScript `for` Loop
    .DESCRIPTION
        Template for a `for` loop in PipeScript (which is just a for loop in PowerShell)
    .NOTES        
        If provided a PowerShell for loop's AST as pipeline input, this should produce the same script. 
    #>
    param(
    # The For Loop's Initialization.
    # This initializes the loop.
    [vbn()]
    [Alias('Initializer')]
    [string]
    $Initialization,

    # The For Loop's Condition.
    # This determine if the loop should continue running.
    [vbn()]
    [string]
    $Condition,
    # The For Loop's Iterator, or Afterthought.
    # This occurs after each iteration of the loop
    [vbn()]
    [Alias('Iterator')]
    [string]
    $Afterthought,

    # The body of the loop
    [vbn()]
    [string]
    $Body,
    
    # The language keyword that represents a `for` loop.  This is usually `for`.
    [vbn()]
    [string]
    $ForKeyword = 'for',

    # The separator between each clause in the `for` loop.  This is usually `;`.
    [vbn()]
    [string]
    $ForSeparator = ';',

    # The sub expression start sequence. This is usually `(`.
    [vbn()]
    [string]
    $SubExpressionStart = '(',
    
    # The sub expression end sequence. This is usually `)`.
    [vbn()]
    [string]
    $SubExpressionEnd = ')',

    # The start of a block.  This is usually `{`
    [string]
    $BlockStart = '{',

    # The end of a block.  This is usually `}`
    [string]
    $BlockEnd = '}'
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        @(
            $ForKeyword
            $SubExpressionStart
            (
                $Initialization,
                    $Condition,
                        $Afterthought -join $ForSeparator
            )
            $SubExpressionEnd
            $BlockStart            
            $Body
            $blockEnd
        ) -join ' '    
    }
}

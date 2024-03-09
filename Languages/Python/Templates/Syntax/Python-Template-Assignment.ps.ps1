[ValidatePattern("Python")]
param()

Template function Assignment.py {
    <#
    .SYNOPSIS
        Template for a Python assignment
    .DESCRIPTION
        Template for Python assignment statements.
    .EXAMPLE
        Template.Assignment.py -Left "a" -Right 1
    #>    
    param(    
    # The variable name.
    [vbn()]
    [Alias('Left','Declaration')]
    [string]
    $VariableName,

    # The value expression
    [Alias('Right','Expression','Initializer')]    
    [string]
    $ValueExpression,

    # The assignment operator.  By default, =.    
    [string]
    $AssignmentOperator = '=',

    # The indentation level.  By default, 0
    [int]
    $Indent = 0
    )

    process {
        "$(' ' * $indent)${VariableName}${AssignmentOperator} $ValueExpression"
    }
}



[ValidatePattern("JavaScript")]
param()


function Template.Assignment.js {

    <#
    .SYNOPSIS
        Template for a JavaScript assignment
    .DESCRIPTION
        Template for JavaScript assignment statements.
    .EXAMPLE
        Template.Assignment.js -Left "a" -Right 1
    .EXAMPLE
        Template.Const.js -VariableName "MyConstant" -Expression 42
    #>
    [Alias('Template.Const.js','Template.Var.js', 'Template.Let.js')]    
    param(    
    # The variable name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Left','Declaration')]
    [string]
    $VariableName,

    # The value expression
    [Alias('Right','Expression','Initializer')]    
    [string]
    $ValueExpression,

    # If set, the assignment will be constant
    [switch]
    $Const,

    # If set, the assignment will be a variant.
    [Alias('Var')]
    [switch]
    $Variant,

    # If set, the assignment will be a locally scoped let.
    [Alias('Local')]
    [switch]
    $Let,

    # The assignment operator.  By default, =.    
    [string]
    $AssignmentOperator = '='
    )

    process {

        if ($MyInvocation.InvocationName -match '\.let') { $let = $true }
        if ($MyInvocation.InvocationName -match '\.var') { $variant = $true }
        if ($MyInvocation.InvocationName -match '\.const') { $const = $true }

    $VariableDeclaration = "${VariableName}${AssignmentOperator} $ValueExpression"
"$(@(
    if ($let) {"let"} 
    elseif ($variant) {"var"} 
    elseif ($const){"const"}
    $VariableDeclaration
) -join ' ')"
    }

}





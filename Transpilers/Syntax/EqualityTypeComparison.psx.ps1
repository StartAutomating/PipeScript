<#
.SYNOPSIS
    Allows equality type comparison.
.DESCRIPTION
    Allows most equality comparison using triple equals (===).

    Many languages support this syntax.  PowerShell does not.    

    This transpiler enables equality and type comparison with ===.
.NOTES
    This will not work if there is a constant on both sides of the expression

    
    if ($one === $one) { "this will work"} 
    if ('' === '')     { "this will not"}
    
.EXAMPLE
    Invoke-PipeScript -ScriptBlock {
        $a = 1
        $number = 1    
        if ($a === $number ) {
            "A is $a"
        }
    }
.EXAMPLE
    Invoke-PipeScript -ScriptBlock {
        $One = 1
        $OneIsNotANumber = "1"
        if ($one == $OneIsNotANumber) {
            'With ==, a number can be compared to a string, so $a == "1"'
        }
        if (-not ($One === $OneIsNotANumber)) {
            "With ===, a number isn't the same type as a string, so this will be false."            
        }
    }
.EXAMPLE
    Invoke-PipeScript -ScriptBlock {
        if ($null === $null) {
            '$Null really is $null'
        }
    }
.EXAMPLE
    Invoke-PipeScript -ScriptBlock {
        $zero = 0
        if (-not ($zero === $null)) {
            '$zero is not $null'
        }
    }
.EXAMPLE
    {
        $a = "b"
        $a === "b"
    } | .>PipeScript
#>
[ValidateScript({
    # This is valid if the assignment statement's
    $AssignmentStatementAST = $_
    # The operator must be an equals
    $AssignmentStatementAST.Operator -eq 'Equals' -and     
    # The right must start with =
    $AssignmentStatementAST.Right -match '^==' -and
    # There must not be space between it and the left
    $AssignmentStatementAST.Parent.ToString() -match "$(
        [Regex]::Escape($AssignmentStatementAST.Left.ToString())
    )\s{0,}===[^=]"
})]
param(
# The original assignment statement.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.AssignmentStatementAst]
$AssignmentStatementAST
)

process {
    if ($AssignmentStatementAST.Left -isnot [Management.Automation.Language.VariableExpressionAST]) {
        Write-Error "Left side of EqualityTypeComparison must be a variable"
        return        
    }
    $leftSide = $AssignmentStatementAST.Left

    foreach ($side in 'Left', 'Right') {        
        $ExecutionContext.SessionState.PSVariable.Set("${side}Side", $AssignmentStatementAST.$side)
    }    
    
    $rightSide = $rightSide -replace '^=='

    # We create a new script by:
    $newScript =
        # Checking for the existence of GetType on both objects (and the same result from each)        
        "(
    (-not $leftSide.GetType -and -not $rightSide.GetType) -or 
    (
        (
            ($leftSide.GetType -and $rightSide.GetType) -and
            ($leftSide.GetType() -eq $rightSide.GetType()
        ) -and (" +
        # then, in a new subexpression
        [Environment]::Newline +
        # taking the left side as-is.
        $AssignmentStatementAST.Left.Extent.ToString() + 
        # replacing the = with ' -eq '
        ' -eq ' +
        # And replacing any the = and any trailing whitespace.
        ($AssignmentStatementAST.Right.Extent.ToString() -replace '^==\s{1,}') + ")
        )
    )
)"
    
    [scriptblock]::Create($newScript)
}


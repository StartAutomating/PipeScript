Template function PipeScript.DoubleEqualCompare {    
    <#
    .SYNOPSIS
        Allows equality comparison.
    .DESCRIPTION
        Allows most equality comparison using double equals (==).

        Many languages support this syntax.  PowerShell does not.    

        This transpiler enables equality comparison with ==.
    .NOTES
        This will not work if there is a constant on both sides of the expression

        
        if ($null == $null) { "this will work"} 
        if ('' == '') { "this will not"}
        
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            $a = 1    
            if ($a == 1 ) {
                "A is $a"
            }
        }
    .EXAMPLE
        {
            $a == "b"
        } | .>PipeScript
    #>
    [ValidateScript({
        # This is valid if the assignment statement's
        $AssignmentStatementAST = $_
        # The operator must be an equals
        $AssignmentStatementAST.Operator -eq 'Equals' -and     
        # The right must start with =
        $AssignmentStatementAST.Right -match '^=' -and
        $AssignmentStatementAST.Parent.ToString() -match "$(
            [Regex]::Escape($AssignmentStatementAST.Left.ToString())
        )\s{0,}==[^=]"
    })]    
    param(
    # The original assignment statement.
    [Parameter(Mandatory,ValueFromPipeline)]
    [Management.Automation.Language.AssignmentStatementAst]
    $AssignmentStatementAST
    )

    process {
        # This is a very trivial transpiler.
        
        # We create a new script by:
        $newScript =
            # taking the left side as-is.
            $AssignmentStatementAST.Left.Extent.ToString() + 
            # replacing the = with ' -eq '
            ' -eq ' +
            # And replacing any the = and any trailing whitespace.
            ($AssignmentStatementAST.Right.Extent.ToString() -replace '^=\s{1,}')
        
        [scriptblock]::Create($newScript)
    }
}


<#
.SYNOPSIS
    Gets a Variable's Likely Type
.DESCRIPTION
    Determines the type of a variable.

    This looks for the closest assignment statement and uses this to determine what type the variable is likely to be.
.NOTES
    Subject to revision and improvement.  While this covers many potential scenarios, it does not always
.EXAMPLE
    {
        [int]$x = 1
        $y = 2
        $x + $y
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetVariableType()
    # Should -Be ([int])
.EXAMPLE
    {
        $x = Get-Process        
        $x + $y
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.Left.GetVariableType()
    # Should -Be ([Diagnostics.Process])
.EXAMPLE
    {
        $x = [type].name
        $x        
    }.Ast.EndBlock.Statements[-1].PipelineElements[0].Expression.GetVariableType()

#>
if ($this.VariablePath.userPath -eq 'psBoundParmeters') {
    return [Management.Automation.PSBoundParametersDictionary]    
}
$assignments = $this.GetAssignments()
$closestAssignment = $assignments[0]

# Our easiest scenario is that the variable is assigned in a parameter
if ($closestAssignment -is [Management.Automation.Language.ParameterAst]) {
    # If so, the .StaticType will give us our variable type.
    return $closestAssignment.StaticType
}

# Our next simple scenario is that the closest assignment is declaring a hashtable
if ($closestAssignment.Right.Expression -is [Management.Automation.Language.HashtableAst]) {    
    return [hashtable]   
}

# The left can be a convert expression.
if ($closestAssignment.Left -is [Management.Automation.Language.ConvertExpressionAst]) {
    # If the left was [ordered]
    if ($closestAssignment.Left.Type.Tostring() -eq '[ordered]') {
        return [Collections.specialized.OrderedDictionary] # return an OrderedDictionary
    } else {
        # If the left side's type can be reflected
        $reflectedType   = $closestAssignment.Left.Type.TypeName.GetReflectionType()
        if ($reflectedType) {
            return $reflectedType # return it.
        }
        else {
            # otherwise, return the left's static type.
            return $closestAssignment.Left.StaticType
        }
    }
}

# Determine if the left side is multiple assignment
$isMultiAssignment =$closestAssignment.Left -is [Management.Automation.Language.ArrayLiteralAst]

# If the left side is not multiple assignment, but the right side is an array
if (-not $isMultiAssignment -and 
    $closestAssignment.Right.Expression -is [Management.Automation.Language.ArrayExpressionAst]) {
    # then the object is an array.
    return [Object[]]
}

# Next, if the right as a convert expression
if ($closestAssignment.Right.Expression -is [Management.Automation.Language.ConvertExpressionAst]) {
    # If it was '[ordered]'
    if ($closestAssignment.Right.Expression.Type.Tostring() -eq '[ordered]') {
        # return an ordered dictionary
        return [Collections.specialized.OrderedDictionary]
    } else {
        # Otherwise, see if we have a reflected type.
        $reflectedType   = $closestAssignment.Right.Expression.Type.TypeName.GetReflectionType()
        if ($reflectedType) { 
            return $reflectedType # If we do, return it.            
        }
        else {
            # If we don't, return the static type of the expression
            return $closestAssignment.Right.Expression.StaticType
        }
    }       
}

if ($closestAssignment.Right.Expression -is [Management.Automation.Language.MemberExpressionAst]) {
    $invokeMemberExpr = $closestAssignment.Right.Expression
    $memberName = $invokeMemberExpr.Member.ToString()
    if ($invokeMemberExpr.Expression.TypeName) {
        $invokeType = $invokeMemberExpr.Expression.TypeName.GetReflectionType()            
        if ($invokeType) {
            $potentialTypes = @(
            foreach ($invokeableMember in $invokeType.GetMember($memberName, "Public, IgnoreCase,$(if ($invokeMemberExpr.Static) { 'Static'} else { 'Instance'})")) {
                if ($invokeableMember.PropertyType) {
                    $invokeableMember.PropertyType
                } elseif ($invokeableMember.ReturnType) {
                    $invokeableMember.ReturnType
                }
            })
            return $potentialTypes | Select-Object -Unique
        }
    }            
}


# The right side could be a pipeline
if ($closestAssignment.Right -is [Management.Automation.Language.PipelineAst]) {
    # If so, walk backwards thru the pipeline
    for ($pipelineElementIndex = $closestAssignment.Right.PipelineElements.Count - 1;
        $pipelineElementIndex -ge 0;
        $pipelineElementIndex--) {
        $commandInfo = $closestAssignment.Right.PipelineElements[$pipelineElementIndex].ResolvedCommand
        # If the command had an output type, return it.
        if ($commandInfo.OutputType) {
            return $commandInfo.OutputType.Type
        }
    }
}

# If we don't know, return nothing
return
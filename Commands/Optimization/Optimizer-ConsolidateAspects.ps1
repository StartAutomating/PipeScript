
function PipeScript.Optimizer.ConsolidateAspects {


    <#
    .SYNOPSIS
        Consolidates Code Aspects
    .DESCRIPTION
        Consolidates any ScriptBlockExpressions with the same content into variables.
    .EXAMPLE
        {        
            a.txt Template 'abc'

            b.txt Template 'abc'
        } | .>PipeScript
    .EXAMPLE
        {
            aspect function SayHi {
                if (-not $args) { "Hello World"}
                else { $args }
            }
            function Greetings {
                SayHi
                SayHi "hallo Welt"
            }
        } | .>PipeScript
    #>
    param(
    # The ScriptBlock.  All aspects used more than once within this ScriptBlock will be consolidated.
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock,

    # The Function Definition.  All aspects used more than once within this Function Definition will be consolidated.
    [Parameter(Mandatory,ParameterSetName='FunctionDefinition',ValueFromPipeline)]
    [Management.Automation.Language.FunctionDefinitionAst]
    $FunctionDefinitionAst
    )

    begin {
        $findAspectComment = [Regex]::new('# aspect\p{P}(?<n>\S+)', 'IgnoreCase,RightToLeft', '00:00:01')
    }

    process {
        if ($psCmdlet.ParameterSetName -eq 'FunctionDefinition') {
            $ScriptBlock = [scriptblock]::Create($FunctionDefinitionAst.Body -replace '^\{' -replace '\}$')
        }

        # Find all ScriptBlockExpressions
        $script:FoundFunctionExtent = $null
        # If we are in a function, we can consolidate inner functions.
        $script:CurrentFunctionExtent =
            if ($psCmdlet.ParameterSetName -eq 'FunctionDefinition') {
                $FunctionDefinitionAst
            } else {
                $null
            }
        $allExpressions = @($ScriptBlock | Search-PipeScript -AstCondition {
            param($ast)
            if ($ast -is [Management.Automation.Language.FunctionDefinitionAst] -and -not $script:CurrentFunctionExtent) {
                $script:FoundFunctionExtent = $ast.Extent
            }
            if ($ast -isnot [Management.Automation.Language.ScriptBlockExpressionAst]) { return $false }            
            
            if ($script:FoundFunctionExtent -and 
                ($ast.Extent.StartOffset -ge $script:FoundFunctionExtent.StartOffset) -and 
                ($ast.Extent.EndOffset -lt $script:FoundFunctionExtent.EndOffset)) {
                return $false
            }
            if ($ast.Parent -is [Management.Automation.Language.AttributeAst]) { 
                return $false
            }
            
            if ($ast.Parent -is [Management.Automation.Language.AssignmentStatementAst]) { 
                return $false
            }

            if ($ast.Parent -is [Management.Automation.Language.CommandAst] -and 
                $ast.Parent.CommandElements[0] -ne $ast) { 
                return $false
            }
            return $true
        } -Recurse)

        $scriptBlockExpressions = [Ordered]@{}
        
        foreach ($expression in $allExpressions) {
            # skip any expression in an attribute
            if ($expression.Parent -is [Management.Automation.Language.AttributeAst]) {
                continue
            }
            # and bucket the rest
            $matchingAst = $expression.Result -replace '\s'
            
            if (-not $scriptBlockExpressions["$matchingAst"]) {
                $scriptBlockExpressions["$matchingAst"]  = @($expression.Result)
            } else {
                $scriptBlockExpressions["$matchingAst"]  += @($expression.Result)
            }
        }


        # Any bucket 
        $consolidations = [Ordered]@{}
        $consolidatedScriptBlocks = [Ordered]@{}
        foreach ($k in $scriptBlockExpressions.Keys) {
            # with 2 or more values
            if ($scriptBlockExpressions[$k].Length -lt 2) {
                continue
            }
            # is fair game for consolidation
            # (if it's not itself
            if ("$k" -eq ("$ScriptBlock" -replace '\s')) {
                continue
            }
            # or blank)
            if ("$k" -match "^\s{0,}\{\s{0,}\}\s{0,}$") {
                continue
            }
            # Of course we have to figure out what the variable we're consolidating into is called
            $potentialNames = 
                @(foreach ($value in $scriptBlockExpressions[$k]) {
                    $grandParent = $value.Parent.Parent
                    $greatGrandParent = $value.Parent.Parent.Parent

                    # If it's in a hashtable, use the key
                    if ($greatGrandParent -is [Management.Automation.Language.HashtableAst]) {
                        foreach ($kvp in $greatGrandParent.KeyValuePairs) {
                            if ($kvp.Item2 -ne $grandParent) { continue }
                            $kvp.Item1
                        }
                    }
                    # If it's in an assignment, use the left side
                    elseif ($greatGrandParent -is [Management.Automation.Language.AssignmentStatementAst]) {
                        $greatGrandParent.Left -replace '^\$'
                    }
                    # If it's a member invocation
                    elseif ($value.Parent -is [Management.Automation.Language.InvokeMemberExpressionAst]) {
                        # use any preceeding value name
                        @(foreach ($arg in $value.Parent.Arguments) {                            
                            if ($arg -is  [Management.Automation.Language.ScriptBlockExpressionAst] -and $arg.Extent.ToString() -eq "$k") {
                                break
                            } elseif ($arg.Value) {
                                $arg.Value
                            }
                        }) -join '_'
                    }
                    elseif (                        
                        # Otherwise, if the previous comment line is "aspect.Name"
                        $greatGrandParent.Parent -and                         
                        "$($greatGrandParent.Parent)".Substring(0,  $greatGrandParent.Extent.StartOffset - $greatGrandParent.Parent.Extent.StartOffset) -match $findAspectComment
                    ) {
                        # it's the aspect name.
                        $matches.n
                    }
                    else {
                        # Otherwise, we don't know what we'd call it (and cannot consolidate)
                        $null = $null
                    }
                })

            $uniquePotentialNames = @{}
            foreach ($potentialName in $potentialNames) {
                $uniquePotentialNames[$potentialName] = $potentialName
            }                         
            if ($uniquePotentialNames.Count -eq 1) {
                $determinedAspectName = "$(@($uniquePotentialNames.Keys))Aspect"
                $consolidatedScriptBlocks[$determinedAspectName] = $scriptBlockExpressions[$k][0]
                foreach ($scriptExpression in $scriptBlockExpressions[$k]) {
                    $consolidations[$scriptExpression] = $determinedAspectName
                }
            }
        }

        # Turn each of the consolidations into a regex replacement
        $astReplacement = [Ordered]@{}
        # and a bunch of content to prepend.
        foreach ($consolidate in $consolidations.GetEnumerator()) {            
            $astReplacement[$consolidate.Key] = [ScriptBlock]::Create('$' + $($consolidate.Value -replace '^\$' + ([Environment]::NewLine)))
        }
        
        $prepend  = if ($consolidatedScriptBlocks) {
            [scriptblock]::Create("$(@(
                foreach ($consolidate in $consolidatedScriptBlocks.GetEnumerator()) {                                
                    "`$$($consolidate.Key) = $($consolidatedScriptBlocks[$consolidate.Key])"                
                }
            ) -join [Environment]::NewLine)")
        }

        $updatedScriptBlock = 
            if ($astReplacement.Count -gt 1) {
                Update-PipeScript -AstReplacement $astReplacement -ScriptBlock $ScriptBlock -Prepend $prepend
            }
            else {
                $ScriptBlock
            }

        switch ($psCmdlet.ParameterSetName) {
            ScriptBlock {
                $updatedScriptBlock
            }
            FunctionDefinition {
                [scriptblock]::Create(
                    @(
                        "$(if ($FunctionDefinitionAst.IsFilter) { "filter"} else { "function"}) $($FunctionDefinitionAst.Name) {"
                        $UpdatedScriptBlock
                        "}"
                    ) -join [Environment]::NewLine
                ).Ast.EndBlock.Statements[0]
            }
        }
    }


}



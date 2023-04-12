
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
    [Parameter(Mandatory,ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock
    )
    process {
        # Find all ScriptBlockExpressions
        $allExpressions = @($ScriptBlock | Search-PipeScript -AstType ScriptBlockExpression)
        $scriptBlockExpressions = [Ordered]@{}
        
        foreach ($expression in $allExpressions) {
            # skip any expression in an attribute
            if ($expression.Parent -is [Management.Automation.Language.AttributeAst]) {
                continue
            }
            # and bucket the rest
            $matchingAst = $expression.Result
            if (-not $scriptBlockExpressions["$matchingAst"]) {
                $scriptBlockExpressions["$matchingAst"]  = @($matchingAst)
            } else {
                $scriptBlockExpressions["$matchingAst"]  += @($matchingAst)
            }
        }
        # Any bucket 
        $consolidations = [Ordered]@{}
        foreach ($k in $scriptBlockExpressions.Keys) {
            # with 2 or more values
            if ($scriptBlockExpressions[$k].Length -lt 2) {
                continue
            }
            # is fair game for consolidation
            # (if it's not itself
            if ("$k" -eq "$ScriptBlock") {
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
                        $(
                        $foundCommentLine = [Regex]::new('^\s{0,}#\saspect\p{P}(?<n>\S+)', "Multiline,RightToLeft").Match(
                            $greatGrandParent.Parent.Extent.ToString(), $grandParent.Extent.StartOffset - $greatGrandParent.Parent.Extent.StartOffset
                        )                        
                        $foundCommentLine.Success
                        )
                    ) {
                        # it's the aspect name.
                        $foundCommentLine.Groups["n"].Value
                    }
                    else {
                        # Otherwise, we don't know what we'd call it (and cannot consolidate)
                        $null = $null
                    }
                })
            $uniquePotentialNames = $potentialNames | Select-Object -Unique
            if ($uniquePotentialNames -and 
                $uniquePotentialNames -isnot [Object[]]) {                
                $consolidations[$k] = $uniquePotentialNames
            }
        }
        # Turn each of the consolidations into a regex replacement
        $regexReplacements = [Ordered]@{}
        # and a bunch of content to prepend.
        $prepend  = [scriptblock]::Create("$(@(
            foreach ($consolidate in $consolidations.GetEnumerator()) {
                $k = [regex]::Escape($consolidate.Key)
                $regexReplacements[$k] = '$' + $($consolidate.Value -replace '^\$' + ([Environment]::NewLine))
                "`$$($consolidate.Value) = $($consolidate.Key)"
            }
        ) -join [Environment]::NewLine)")
        Update-PipeScript -RegexReplacement $regexReplacements -ScriptBlock $ScriptBlock -Prepend $prepend
    }
}



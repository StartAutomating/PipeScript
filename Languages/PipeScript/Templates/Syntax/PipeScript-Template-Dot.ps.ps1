[ValidatePattern("PipeScript")]
param()

Template function PipeScript.Dot {
    <#
    .SYNOPSIS
        Dot Notation
    .DESCRIPTION
        Dot Notation simplifies multiple operations on one or more objects.

        Any command named . (followed by a letter) will be treated as the name of a method or property.    

        If it is followed by parenthesis, these will be treated as method arguments.

        If it is followed by a ScriptBlock, a dynamic property will be created that will return the result of that script block.

        If any other arguments are found before the next .Name, they will be considered arguments to a method.
    .EXAMPLE
        .> {
            [DateTime]::now | .Month .Day .Year
        }
    .EXAMPLE
        .> {
            "abc", "123", "abc123" | .Length
        }
    .EXAMPLE
        .> { 1.99 | .ToString 'C' [CultureInfo]'gb-gb' }
    .EXAMPLE
        .> { 1.99 | .ToString('C') }
    .EXAMPLE
        .> { 1..5 | .Number { $_ } .Even { -not ($_ % 2) } .Odd { ($_ % 2) -as [bool]} }
    .EXAMPLE
        .> { .ID { Get-Random } .Count { 0 } .Total { 10 }}
    .EXAMPLE
        .> {
            # Declare a new object
            .Property = "ConstantValue" .Numbers = 1..100 .Double = {
                param($n)
                $n * 2
            } .EvenNumbers = {
                $this.Numbers | Where-Object { -not ($_ % 2)}
            } .OddNumbers = {
                $this.Numbers | Where-Object { $_ % 2}
            }
        }
    #>
    [ValidateScript({
        $commandAst = $_
        $DotChainPattern = '^\.\p{L}'
        if (-not $commandAst.CommandElements) { return $false }
        $commandAst.CommandElements[0].Value -match $DotChainPattern
    })]
    param(
    [Parameter(Mandatory,ParameterSetName='Command',ValueFromPipeline)]
    [Management.Automation.Language.CommandAst]
    $CommandAst
    )

    begin {
        $DotProperty = {        
if ($in.PSObject.Methods[$PropertyName].OverloadDefinitions -match '\(\)$') {
    $in.$PropertyName.Invoke()
} elseif ($in.PSObject.Properties[$PropertyName]) {
    $in.$PropertyName
}
        }

        $DotMethod = { $in.$MethodName($MethodArguments) }
    }

    process {

        # Create a collection for the entire chain of operations and their arguments.
        $DotChain     = @()
        $DotArgsAst   = @()
        $DotChainPart = ''
        $DotChainPattern = '^\.\p{L}'

        $targetCommandAst = $CommandAst
        $commandSequence  = @()
        $lastCommandAst   = $null
        # Then, walk over each element of the commands
        $CommandElements = @(do {
            $lastCommandAst = $targetCommandAst
            $commandSequence += $targetCommandAst
            $targetCommandAst.CommandElements
            # If the grandparent didn't have a list of statements, this is the only dot sequence in the chain.
            if (-not $CommandAst.Parent.Parent.Statements) { break }
            $nextStatementIndex = $commandAst.Parent.Parent.Statements.IndexOf($targetCommandAst.Parent) + 1
            $nextStatement      = $CommandAst.Parent.Parent.Statements[$nextStatementIndex]         
            if ($nextStatement -isnot [Management.Automation.Language.PipelineAst]) {
                break
            }
            if ($nextStatement.PipelineElements[0] -isnot 
                [Management.Automation.Language.CommandAst]) {
                break
            }
            if ($nextStatement.PipelineElements[0].CommandElements[0].Value -notmatch 
                $DotChainPattern) {
                break
            }
            $targetCommandAst = $CommandAst.Parent.Parent.Statements[$nextStatementIndex].PipelineElements[0]
        } while ($targetCommandAst))
                
        for ( $elementIndex =0 ; $elementIndex -lt $CommandElements.Count; $elementIndex++) {
            # If we are on the first element, or the command element starts with the DotChainPattern
            if ($elementIndex -eq 0 -or $CommandElements[$elementIndex].Value -match $DotChainPattern) {
                if ($DotChainPart) {
                    $DotChain += [PSCustomObject]@{
                        PSTypeName = 'PipeScript.Dot.Chain'
                        Name       = $DotChainPart
                        Arguments  = $DotArgsAst
                    }
                }

                $DotArgsAst = @()

                # A given step started with dots can have more than one step in the chain specified.
                $elementDotChain = $CommandElements[$elementIndex].Value.Split('.')
                [Array]::Reverse($elementDotChain)
                $LastElement, $otherElements = $elementDotChain
                if ($otherElements) {
                    foreach ($element in $otherElements) {
                        $DotChain += [PSCustomObject]@{
                            PSTypeName = 'PipeScript.Dot.Chain'
                            Name       = $element
                            Arguments  = @()
                        }
                    }
                }
                
                $DotChainPart = $LastElement
            }
            # If we are not on the first index or the element does not start with a dot, it is an argument.
            else {
                $DotArgsAst += $CommandElements[$elementIndex]
            }
        }

        if ($DotChainPart) {
            $DotChain += [PSCustomObject]@{
                PSTypeName = 'PipeScript.Dot.Chain'
                Name       = $DotChainPart
                Arguments  = $DotArgsAst
            }
        }


        $NewScript = @()
        $indent    = 0
        $WasPipedTo = $CommandAst.IsPipedTo        

        # By default, we are not creating a property bag.
        # This default will change if:
        # * More than one property is defined
        # * A property is explicitly assigned
        $isPropertyBag = $false

        # If we were piped to, adjust indent (for now)
        if ($WasPipedTo) {
            $indent += 4
        }

        # Declare the start of the chain (even if we don't use it)
        $propertyBagStart = (' ' * $indent) + '[PSCustomObject][Ordered]@{'
        # and keep track of all items we must post process.
        $PostProcess      = @()

        # If more than one item was in the chain
        if ($DotChain.Length -ge 0) { 
            $indent += 4 # adjust indentation
        }   

        # Walk thru all items in the chain of properties.
        foreach ($Dot in $DotChain) {
            $firstDotArg, $secondDotArg, $restDotArgs = $dot.Arguments
            # Determine what will be the segment of the dot chain.
            $thisSegement =
                # If the dot chain has no arguments, treat it as a property
                if (-not $dot.Arguments) {                
                    $DotProperty -replace '\$PropertyName', "'$($dot.Name)'"
                }
                # If the dot chain's first argument is an assignment 
                elseif ($firstDotArg -is [Management.Automation.Language.StringConstantExpressionAst] -and 
                    $firstDotArg.Value -eq '=') {
                    $isPropertyBag = $true
                    # and the second is a script block
                    if ($secondDotArg -is [Management.Automation.Language.ScriptBlockExpressionAst]) {
                        # it will become either a [ScriptMethod] or [ScriptProperty]
                        $secondScriptBlock = [ScriptBlock]::Create(
                            $secondDotArg.Extent.ToString() -replace '^\{' -replace '\}$'
                        )
                                        
                        # If the script block had parameters (even if they were empty parameters)
                        # It should become a ScriptMethod
                        if ($secondScriptBlock.Ast.ParamBlock) {
                            "[PSScriptMethod]::New('$($dot.Name)', $secondDotArg)"
                        } else {
                            # Otherwise, it will become a ScriptProperty
                            "[PSScriptProperty]::New('$($dot.Name)', $secondDotArg)"
                        }
                        $PostProcess += $dot.Name
                    }
                    # If we had an array of arguments, and both elements were ScriptBlocks
                    elseif ($secondDotArg -is [Management.Automation.Language.ArrayLiteralAst] -and 
                        $secondDotArg.Elements.Count -eq 2 -and 
                        $secondDotArg.Elements[0] -is [Management.Automation.Language.ScriptBlockExpressionAst] -and
                        $secondDotArg.Elements[1] -is [Management.Automation.Language.ScriptBlockExpressionAst]
                    ) {
                        # Then we will treat this as a settable script block
                        $PostProcess += $dot.Name
                        "[PSScriptProperty]::New('$($dot.Name)', $($secondDotArg.Elements[0]), $($secondDotArg.Elements[1]))"
                    }
                    elseif (-not $restDotArgs) {
                        # Otherwise, if we only have one argument, use the expression directly
                        $secondDotArg.Extent.ToString()
                    } elseif ($restDotArgs) {
                        # Otherwise, if we had multiple values, create a list.
                        @(
                            $secondDotArg.Extent.ToString()
                            foreach ($otherDotArg in $restDotArgs) {
                                $otherDotArg.Extent.Tostring()
                            }
                        ) -join ','
                    }                
                }
                # If the dot chain's first argument is a ScriptBlock
                elseif ($firstDotArg -is [Management.Automation.Language.ScriptBlockExpressionAst]) 
                {
                    # Run that script block
                    "& $($firstDotArg.Extent.ToString())"
                } 
                elseif ($firstDotArg -is [Management.Automation.Language.ParenExpressionAst]) {
                    # If the first argument is a parenthesis, assume the contents to be method arguments
                    $DotMethod -replace '\$MethodName', $dot.Name -replace '\(\$MethodArguments\)',$firstDotArg.ToString()
                }
                else {
                    # If the first argument is anything else, assume all remaining arguments to be method parameters.                
                    $DotMethod -replace '\$MethodName', $dot.Name -replace '\(\$MethodArguments\)',(
                        '(' + ($dot.Arguments -join ',') + ')'
                    )                        
                }
        
            # Now we add the segment to the total script
            $NewScript +=            
                if (-not $isPropertyBag -and $DotChain.Length -eq 1 -and $thisSegement -notmatch '^\[PS') {
                    # If the dot chain is a single item, and not part of a property bag, include it directly
                    "$(' ' * ($indent - 4))$thisSegement"
                } else {
                    
                    $isPropertyBag = $true
                    # Otherwise include this segment as a hashtable assignment with the correct indentation.
                    $thisSegement = @($thisSegement -split '[\r\n]+' -ne '' -replace '$', (' ' * 8)) -join [Environment]::NewLine
                @"
$(' ' * $indent)'$($dot.Name.Replace("'","''"))' =
$(' ' * ($indent + 4))$thisSegement
"@
                }
        }

    
        # If we were generating a property bag
        if ($isPropertyBag) {
            if ($WasPipedTo) { # and it was piped to
                # Add the start of the pipeline and the property bag start to the top of the script.
                $NewScript = @('& { process {') + ((' ' * $indent) + '$in = $this = $_') + $propertyBagStart + $NewScript 
            } else {
                # If it was not piped to, just add the start of the property bag
                $newScript = @($propertyBagStart) + $NewScript
            }
        } elseif ($WasPipedTo)  {
            # If we were piped to (but were not a property bag)
            $indent -= 4
            # add the start of the pipeline to the top of the script.
            $newScript = @('& { process {') + ((' ' * $indent) + '$in = $this = $_') + $NewScript
        }
        
        # If we were a property bag
        if ($isPropertyBag) {
            # close out the script
            $NewScript += ($(' ' * $indent) + '}')
            $indent -= 4
        }

        # If there was post processing
        if ($PostProcess) {
            # Change the property bag start to assign it to a variable
            $NewScript = $newScript -replace ($propertyBagStart -replace '\W', '\$0'), "`$Out = $propertyBagStart"
            foreach ($post in $PostProcess) {
                # and change any [PSScriptProperty] or [PSScriptMethod] into a method on that object.
                $newScript += "`$Out.PSObject.Members.Add(`$out.$Post)"
            }
            # Then output.
            $NewScript += '$Out'
        }
        
        # If we were piped to
        if ($WasPipedTo) {   
            # close off the script.     
            $NewScript += '} }'
        } else {
            # otherwise, make it a subexpression
            $NewScript = '$(' + ($NewScript -join [Environment]::NewLine) + ')'
        }

        $NewScript = $NewScript -join [Environment]::Newline

        # Return the created script.
        $newScriptBlock = [scriptblock]::Create($NewScript)

        if ($targetCommandAst -ne $CommandAst) {
            $newScriptBlock | Add-Member NoteProperty SkipUntil $commandSequence
        }
        $newScriptBlock
    }
}
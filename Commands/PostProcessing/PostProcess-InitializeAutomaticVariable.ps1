
function PipeScript.PostProcess.InitializeAutomaticVariables {
    <#
    .SYNOPSIS
        Initializes any automatic variables
    .DESCRIPTION
        Initializes any automatic variables at the beginning of a script block.
        This enables Automatic?Variable* and Magic?Variable* commands to be populated and populated effeciently.
            
    .EXAMPLE
        Import-PipeScript {
            Automatic.Variable. function MyCallstack {
                Get-PSCallstack
            }
        }
        {
            $MyCallstack
        } | Use-PipeScript
        
    #>
    param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock
    )
    begin {
        # First, let's find all commands that automatic or magic variables.
        # Let's find all possible commands by wildcards (Automatic?Variable* or Magic?Variable*)
        $allAutomaticVariableCommands = @(
            $ExecutionContext.SessionState.InvokeCommand.GetCommands('Automatic?Variable?*','Function', $true) -match '^Automatic\p{P}Variable\p{P}'
            $ExecutionContext.SessionState.InvokeCommand.GetCommands('Magic?Variable?*','Function', $true) -match '^Magic\p{P}Variable\p{P}'
        )
        # Then, let's create a lookup table by the name of the automatic variable
        $allAutomaticVariables = [Ordered]@{}
        
        foreach ($automaticVariableCommand in $allAutomaticVariableCommands) {
            # The automatic variable name is 
            $AutomaticVariableName = 
                # the magic|automatic followed by punctuation followed by variable followed by punctuation.
                $automaticVariableCommand -replace '^(?>Magic|Automatic)\p{P}Variable\p{P}'
            $allAutomaticVariables[$AutomaticVariableName] = 
                $automaticVariableCommand
        }
        
        # Once we've collected all of these automatic variables, the keys are all of the names.
        $allAutomaticVariableNames = $allAutomaticVariables.Keys        
    }
    process {
        # Find all Variables
        $allVariables = @($ScriptBlock | Search-PipeScript -AstType VariableExpressionAst -Recurse | Select-Object -ExpandProperty Result)
        # If there were no variables in this script block, return.
        if (-not $allVariables) { return }
        # Let's collect all of the variables we need to define
        $prependDefinitions = [Ordered]@{}
        foreach ($var in $allVariables) {
            $variableName = "$($var.VariablePath)"
            # If we have an automatic variable by that variable name
            if ($allAutomaticVariables[$variableName]) {
                # stringify it's script block and add it to our dictionary of prepends
                $prependDefinitions[$variableName] = "$($allAutomaticVariables[$variableName].ScriptBlock)" -replace '^\s{0,}' -replace '\s{0,}$'
            }
        }
        # If we neeed to prepend anything
        if ($prependDefinitions.Count) {
            # make it all one big string
            $toPrepend = 
                foreach ($toPrepend in $prependDefinitions.GetEnumerator()) {
                    $variableName = $toPrepend.Key
                    # Define the automatic variable by name
                    $(if ($variableName -match '\p{P}') { # (if it had punctuation)
                        "`${$($variableName)}" # enclose in brackets
                    } else { # otherwise
                        "`$$($variableName)" # just use $VariableName
                    }) + '=' + "`$($($toPrepend.Value))" # prepend the definition of the function within $()
                    # Why?  Because this way, the automatic variable is declared at the same scope as the ScriptBlock.
                    # (By the way, this means you cannot have _any_ parameters on an automatic variable)
                }
            
            # Turn our big string into a script block
            $toPrepend = [ScriptBlock]::create( $toPrepend)
            # and prepend it to this script block.
            Update-ScriptBlock -ScriptBlock $scriptBlock -Prepend $toPrepend
        }
    }
}




PipeScript.PostProcess function InitializeAutomaticVariables {
    <#
    .SYNOPSIS
        Initializes any automatic variables
    .DESCRIPTION
        Initializes any automatic variables at the beginning of a script block.

        This enables Automatic?Variable* and Magic?Variable* commands to be populated and populated effeciently.
        
        For example:
        * If a function exists named Automatic.Variable.MyCallstack
        * AND $myCallStack is used within a ScriptBlock

        Then the body of Automatic.Variable.MyCallstack will be added to the top of the ScriptBlock.

    .EXAMPLE
        # Declare an automatic variable, MyCallStack
        Import-PipeScript {
            Automatic.Variable function MyCallstack {
                Get-PSCallstack
            }
        }

        # Now we can use $MyCallstack as-is.
        # It will be initialized at the beginning of the script
        {
            $MyCallstack
        } | Use-PipeScript
    #>
    param(
    [vfp(Mandatory,ParameterSetName='ScriptBlock')]
    [scriptblock]
    $ScriptBlock,

    [vfp(Mandatory,ParameterSetName='FunctionDefinition')]
    [Management.Automation.Language.FunctionDefinitionAst]
    $FunctionDefinitionAst
    )

    begin {
        # First, let's find all commands that automatic or magic variables.
        # Let's find all possible commands by wildcards (Automatic?Variable* or Magic?Variable*)
        $allAutomaticVariableCommands = @(
            $ExecutionContext.SessionState.InvokeCommand.GetCommands('*Automatic?Variable?*','Function,Alias,Cmdlet', $true) -match '^Automatic\p{P}Variable\p{P}'
            $ExecutionContext.SessionState.InvokeCommand.GetCommands('*Magic?Variable?*','Function,Alias,Cmdlet', $true) -match '^Magic\p{P}Variable\p{P}'
        )
        # Then, let's create a lookup table by the name of the automatic variable
        $allAutomaticVariables = [Ordered]@{}
        
        foreach ($automaticVariableCommand in $allAutomaticVariableCommands) {
            # The automatic variable name is 
            $AutomaticVariableName = 
                # the magic|automatic followed by punctuation followed by variable followed by punctuation.
                $automaticVariableCommand -replace '(?>Magic|Automatic)\p{P}Variable\p{P}' -replace '\p{P}$' -replace '^(?>PowerShell|PipeScript)'
            $allAutomaticVariables[$AutomaticVariableName] = 
                $automaticVariableCommand
        }
        
        # Declare a quick filter to get the definition of the automatic variable
        filter GetAutomaticVariableDefinition {
            $automaticVariableCommand = $_
            if (-not $automaticVariableCommand) {
                $automaticVariableCommand = $args
            }

            # Resolve any alias as far as we can
            while ($automaticVariableCommand -is [Management.Automation.AliasInfo]) {
                $automaticVariableCommand = $automaticVariableCommand.ResolvedCommand
            }

            # If we've resolved to a function
            if ($automaticVariableCommand -is [Management.Automation.FunctionInfo]) {
                # take a quick second to check that the function is "right"
                if (-not $automaticVariableCommand.ScriptBlock.Ast.Body.EndBlock) {
                    Write-Error "$automaticVariableCommand does not have an end block"
                } elseif (-not $automaticVariableCommand.ScriptBlock.Ast.Body.EndBlock.Unnamed) {
                    Write-Error "$automaticVariableCommand end block should not be named"
                } else {
                    # if it is, inline it's scriptblock (trimmed of some whitespace).
                    "$($automaticVariableCommand.ScriptBlock.Ast.Body.EndBlock.ToString())" -replace '^\s{0,}' -replace '\s{0,}$'
                }                
            }
            # If we've resolved to a cmdlet
            elseif ($automaticVariableCommand -is [Management.Automation.CmdletInfo]) {
                # call it directly
                "$($automaticVariableCommand)"
            }
        }
    }

    process {
        $inObj = $_

        if ($psCmdlet.ParameterSetName -eq 'FunctionDefinition') {
            $ScriptBlock = [scriptblock]::Create($FunctionDefinitionAst.Body -replace '^\{' -replace '\}$')
        }
        # Find all Variables
        $allVariables = @($ScriptBlock | Search-PipeScript -AstType VariableExpressionAst | Select-Object -ExpandProperty Result)
        
        # If there were no variables in this script block, return.
        return if -not $allVariables


        # Let's collect all of the variables we need to define
        $prependDefinitions = [Ordered]@{}
        foreach ($var in $allVariables) {
            $variableName = "$($var.VariablePath)"
            # If we have an automatic variable by that variable name
            if ($allAutomaticVariables[$variableName]) {
                # stringify it's script block and add it to our dictionary of prepends
                $prependDefinitions[$variableName] = $allAutomaticVariables[$variableName] | GetAutomaticVariableDefinition                    
            }
        }

        # If we neeed to prepend anything
        if ($prependDefinitions.Count) {
            # make it all one big string
            $toPrepend = 
                foreach ($toPrepend in $prependDefinitions.GetEnumerator()) {
                    $variableName  = $toPrepend.Key
                    $variableValue = $toPrepend.Value
                    if ($variableValue -notmatch '^\@[\(\{\[]' -or 
                        $variableValue -match '[\r\n]') {
                        $variableValue = "`$($variableValue)"
                    }
                    # Define the automatic variable by name
                    $(if ($variableName -match '\p{P}') { # (if it had punctuation)
                        "`${$($variableName)}" # enclose in brackets
                    } else { # otherwise
                        "`$$($variableName)" # just use $VariableName
                    }) + '=' + "$variableValue" # prepend the definition of the function.
                    # Why?  Because this way, the automatic variable is declared at the same scope as the ScriptBlock.
                    # (By the way, this means you cannot have _any_ parameters on an automatic variable)
                }
            
            # Turn our big string into a script block
            $toPrepend = [ScriptBlock]::create($toPrepend)
            # and prepend it to this script block.            
            $updatedScriptBlock = Update-ScriptBlock -ScriptBlock $scriptBlock -Prepend $toPrepend
            switch ($psCmdlet.ParameterSetName) {
                ScriptBlock {
                    $updatedScriptBlock
                }
                FunctionDefinition {
                    [scriptblock]::Create(
                        @(
                            "$(if ($FunctionDefinitionAst.IsFilter) { "filter"} else { "function"}) $($functionDefinition.Name) {"
                            $UpdatedScriptBlock
                            "}"
                        ) -join [Environment]::NewLine
                    ).Ast.EndBlock.Statements[0]
                }
            }
        }
    }
}


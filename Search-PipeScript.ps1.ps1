function Search-PipeScript
{
    <#
    .Synopsis
        Searches PowerShell and PipeScript ScriptBlocks
    .Description
        Searches PowerShell and PipeScript ScriptBlocks, files, and text
    .Example
        Search-PipeScript -ScriptBlock {
            $a
            $b
            $c
            "text"
        } -AstType Variable
    .LINK
        Update-PipeScript
    #>
    [OutputType('Search.PipeScript.Result')]
    [Alias('Search-ScriptBlock')]
    param(
    # The ScriptBlock that will be searched.
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('ScriptBlock','Text')]
    [ValidateTypes(TypeName={[string], [scriptblock],[IO.FileInfo]})]
    $InputObject,

    # The AST Condition.
    # These Script Blocks
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ASTDelegate')]
    [ScriptBlock[]]
    $AstCondition,

    # A shortname for the abstract syntax tree types.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateTypes(TypeName={[string], [Regex], [string[]], [regex[]]})]
    $AstType,
    
    # One or more regular expressions to match.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('RegEx')]
    [ValidateTypes(TypeName={[string], [Regex], [string[]], [regex[]]})]
    $RegularExpression
    )

    process {
        $ScriptBlock = $null
        $Text        = $null

        # If the input was a file
        if ($InputObject -is [IO.FileInfo]) {
            $inputCommand = # get the resolved command
                $ExecutionContext.SessionState.InvokeCommand.GetCommand(
                    $InputObject.Fullname, 'ExternalScript,Application')
            # If the command was an external script
            if ($inputCommand -is [Management.Automation.ExternalScriptInfo]) {
                # Use it's ScriptBlock
                $ScriptBlock = $inputCommand.ScriptBlock                
            }
            # If the command was an application, and it looks like PipeScript
            elseif (
                $inputCommand -is [Management.Automation.ApplicationInfo] -and 
                $inputCommand.Source -match '\.ps$'
            ) {
                # Load the file text
                $text = [IO.File]::ReadAllText($inputCommand.Source)
                # and create a script block.
                $scriptBlock = [ScriptBlock]::Create($text)
            }
            # Otherwise
            else 
            {
                # Read the file contents as text.
                $text = [IO.File]::ReadAllText($inputCommand.Source)
            }
        }        

        # If the inputObject was a [ScriptBlock]
        if ($InputObject -is [scriptblock]) {
            $scriptBlock = $InputObject # set $ScriptBlock
        }

        # If the InputObject is a string
        if ($InputObject -is [string]) {
            $Text = $InputObject # set $Text.
        }

        # If we have a ScriptBlock
        if ($scriptBlock) {
            # Reset $text to the ScriptBlock contents.
            $Text = "$scriptBlock"

            # If we have an ASTType to find
            if ($AstType) {
                foreach ($astTypeName in $AstType) {
                    # See if it's a real type
                    $realAstType = 
                        foreach ($potentialType in $AstType,
                        "Management.Automation.Language.$AstType",
                        "Management.Automation.Language.${AstType}AST"
                        ) {
                            if ($potentialType -as [type]) {
                                $potentialType -as [type]; break
                            }
                        }
                                        
                    # If it was a real type, but in the wrong namespace
                    if ($realAstType -and $realAstType.Namespace -eq 'Management.Automation.Language') {
                        Write-Error "'$astType' is not an AST type" # error and continue.
                        continue
                    }

                    # Set the search condition
                    $condition =
                        if ($realAstType) {
                            # If there was a real type, search for it.
                            [ScriptBlock]::Create('param($ast) $ast -is [' + $realAstType.FullName + ']')
                        } 
                        elseif ($astType -is [Regex]) {
                            [scriptblock]::Create((
                                'param($ast)
                                $ast.GetType().Name -match ([Regex]::New(' + 
                                $astType.ToString().Replace("'", "''") + "','" +
                                $astType.Options + "','" +
                                $(if ($AstType.MatchTimeout -lt 0) {
                                    '00:00:05'
                                } else {
                                    $AstType.MatchTimeout.ToString()
                                }) + '))'
                            ))
                        }
                        elseif ($astType -as [regex]) {
                            [ScriptBlock]::Create('param($ast) $ast.GetType().Name -match "'+ $astType +'"')
                        } else {
                            [ScriptBlock]::Create('param($ast) $ast.GetType().Name -like  "*' + $astType +'*"')
                        }
                    
                    $AstCondition += $condition
                }
            }

            if ($AstCondition) {
                foreach ($condition in $AstCondition) {
                    $ScriptBlock.Ast.FindAll($condition, $true) | 
                        .InputObject = $inputObject .Result { 
                            $_
                        } .Expression = $condition .ScriptBlock {
                            $ScriptBlock
                        } .PSTypeName = "Search.PipeScript.Result"
                }
            }
        }

        if ($text) {
            if ($RegularExpression) {
                foreach ($regex in $RegularExpression) {
                    $realRegex = 
                        if ($regex -is [regex]) {
                            $regex
                        } else {
                            [Regex]::new($regex)
                        }
                    
                    $realRegex.Matches($text) | 
                        .InputObject = $InputObject .Result {
                            $_
                        } .Expression = $realRegex .RegularExpression {
                            $realRegex
                        } .PSTypeName = "Search.PipeScript.Result"
                }
            }
        }
    }
}


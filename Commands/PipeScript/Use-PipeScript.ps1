function Use-PipeScript
{
    <#
    .Synopsis
        Uses PipeScript Transpilers
    .Description
        Runs an individual PipeScript Transpiler.
        This command must be used by it's smart aliases (for example ```.>PipeScript```).
    .Example
        { "Hello World" } | .>PipeScript # Returns an unchanged ScriptBlock, because there was nothing to run.
    .LINK
        Get-Transpiler
    #>
    [CmdletBinding()]
    param()

    dynamicParam {
        # If we didn't have a Converter library, create one.
        if (-not $script:PipeScriptConverters) { $script:PipeScriptConverters = @{} }

        $myInv = $MyInvocation
        # Then, determine what the name of the pattern in the library would be.
        $NameRegex = '[=\.\<\>@\$\!\*]+(?<Name>[\p{L}\p{N}\-\.\+]+)[=\.\<\>@\$\!\*]{0,}'

        $myInvocationName = ''

        $mySafeName =
            if ('.', '&' -contains $myInv.InvocationName -and
                $(
                    $myInvocationName = $myInv.Line.Substring($MyInvocation.OffsetInLine)
                    $myInvocationName -match "^\s{0,}$NameRegex"
                ) -or 
                $(
                    $myInvocationName = $myInv.Line.Substring($MyInvocation.OffsetInLine) -match
                    $myInvocationName -match "^\s{0,}\$\{$NameRegex}"
                )
            )
            {
                $matches.Name
            }
            elseif ($MyInv.InvocationName)
            {
                $myInv.InvocationName -replace $NameRegex, '${Name}'
                $myInvocationName = $myInv.InvocationName
            }
            else {
                $callstackPeek = @(Get-PSCallStack)[-1]
                $callerCommand = $callstackPeek.InvocationInfo.MyCommand.ToString()
                $CallerName =
                    if ($callerCommand -match "-Name\s{0,1}(?<Name>\S+)") {
                        $matches.Name
                    } elseif ($callerCommand -match '(?>gcm|Get-Command)\s{0,1}(?<Name>\S+)') {
                        $matches.Name
                    }

                if ($callerName) {
                    $myInvocationName = $CallerName
                    $callerName -replace $NameRegex, '${Name}'
                }
            }

        if (-not $mySafeName -or $mySafeName -eq 'Use-PipeScript') {
            $mySafeName = 'PipeScript'
        }

        # Find the Converter in the library
        if (-not $script:PipeScriptConverters[$mySafeName]) {
            $converter = Get-Transpiler | Where-Object DisplayName -eq $mySafeName
            $script:PipeScriptConverters[$mySafeName] = $converter
        }

        $converter = $script:PipeScriptConverters[$mySafeName]
        
        
        if ($converter.Metadata.'PipeScript.Keyword') {                        
            $keywordDynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()            
            $keywordDynamicParameters.Add('ArgumentList', [Management.Automation.RuntimeDefinedParameter]::new(
                'ArgumentList',
                ([PSObject[]]),
                @(
                    $paramAttr = [Management.Automation.ParameterAttribute]::new()
                    $paramAttr.ValueFromRemainingArguments = $true
                    $paramAttr                
                )
            ))
            $keywordDynamicParameters.Add('InputObject', [Management.Automation.RuntimeDefinedParameter]::new(
                'InputObject',
                ([PSObject]),
                @(
                    $paramAttr = [Management.Automation.ParameterAttribute]::new()
                    $paramAttr.ValueFromPipeline = $true
                    $paramAttr                
                )
            ))
            $keywordDynamicParameters            
        } elseif ($converter) {
            $converter.GetDynamicParameters()
        }

    }

    begin {
        $steppablePipelines =
            @(if ($mySafeName -or $psBoundParameters['Name']) {
                $names = @($mySafeName) + $psBoundParameters['Name']
                if ($names) {                
                    $null  = $psBoundParameters.Remove('Name')
                }
                foreach ($cmd in $script:PipeScriptConverters[$names]) {
                    if ($cmd.Metadata.'PipeScript.Keyword') {
                        continue
                    }
                    $steppablePipeline = {& $cmd @PSBoundParameters }.GetSteppablePipeline($MyInvocation.CommandOrigin)
                    $null = $steppablePipeline.Begin($PSCmdlet)
                    $steppablePipeline
                }
                $psBoundParameters['Name'] = $names
            })

        $keywordScript = 
            if (-not $steppablePipelines) {
                $myInv = $myinvocation
                $callstackPeek = @(Get-PSCallStack)[1]
                $CommandAst = if ($callstackPeek.InvocationInfo.MyCommand.ScriptBlock) {
                    @($callstackPeek.InvocationInfo.MyCommand.ScriptBlock.Ast.FindAll({
                        param($ast) 
                            $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                            $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                            $ast -is [Management.Automation.Language.CommandAst]
                    },$true))
                } else {
                    $lineScriptBlock = try { [ScriptBlock]::create($callstackPeek.InvocationInfo.Line) } catch { $null }
                    $lineScriptBlock.Ast.FindAll({
                        param($ast) 
                        $ast.Extent.StartLineNumber -eq $myInv.ScriptLineNumber -and
                        $ast.Extent.StartColumnNumber -eq $myInv.OffsetInLine -and 
                        $ast -is [Management.Automation.Language.CommandAst]
                    },$true)
                }
                if ($CommandAst) {
                    $commandAst | & $converter
                }
            }

        $accumulatedInput = [Collections.Queue]::new()
    }

    process {
        $myParams = @{} + $psBoundParameters
        if (-not $mySafeName) {
            Write-Error "Must call Use-Pipescript with one of it's aliases."
            return
        }
        elseif ($steppablePipelines) {
            $in = $_
            foreach ($sp in $steppablePipelines) {
                $sp.Process($in)
            }
            return
        } elseif (-not $steppablePipelines) {
            
            if ($myParams["InputObject"]) {
                $accumulatedInput.Enqueue($myParams["InputObject"])
            } else {
                & $keywordScript
            }
        }
        
    }

    end {
        if ($accumulatedInput.Count -and $keywordScript) {
            # When a script is returned for a given keyword, it will likely be wrapped in a process block
            # because that is what allows the transpiled code to run the most effeciently.
            # Since we're running this ad-hoc, we need to change the statement slightly,
            # so we're left with a script block that has a process block.
            if ($keywordScript -match '^[\.\&]\s{0,}\{') {
                $keywordScript = [ScriptBlock]::Create(($keywordScript -replace '^[\.\&]\s{0,}\{' -replace '\}$'))
            }
            $accumulatedInput.ToArray() | & $keywordScript
        }
        foreach ($sp in $steppablePipelines) {
            $sp.End()
        }
    }
}

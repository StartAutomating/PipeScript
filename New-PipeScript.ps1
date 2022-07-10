function New-PipeScript {
    <#
    .Synopsis
        Creates new PipeScript.
    .Description
        Creates new PipeScript and PowerShell ScriptBlocks.
    .EXAMPLE
        New-PipeScript -Parameter @{a='b'}
    #>
    [Alias('New-ScriptBlock')]
    param(
    # Defines one or more parameters for a ScriptBlock.
    # Parameters can be defined in a few ways:
    # * As a ```[Collections.Dictionary]``` of Parameters
    # * As the ```[string]``` name of an untyped parameter.
    # * As an  ```[Object[]]```.
    # * As a ```[ScriptBlock]```
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
    $validTypeList = [System.Collections.IDictionary],[System.String],[System.Object[]],[System.Management.Automation.ScriptBlock]
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'System.Collections.IDictionary','string','System.Object[]','scriptblock'."
    }
    return $true
    })]
        
    $Parameter,
    
    # The dynamic parameter block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if ($_.Ast.DynamicParamBlock -or $_.Ast.BeginBlock -or $_.Ast.ProcessBlock) {
            throw "ScriptBlock should not have any named blocks"
        }
        return $true    
    })]
    [ValidateScript({
        if ($_.Ast.ParamBlock.Parameters.Count) {
            throw "ScriptBlock should not have parameters"
        }
        return $true    
    })]
    [Alias('DynamicParameterBlock')]
    [ScriptBlock]
    $DynamicParameter,
    # The begin block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if ($_.Ast.DynamicParamBlock -or $_.Ast.BeginBlock -or $_.Ast.ProcessBlock) {
            throw "ScriptBlock should not have any named blocks"
        }
        return $true    
    })]
    [ValidateScript({
        if ($_.Ast.ParamBlock.Parameters.Count) {
            throw "ScriptBlock should not have parameters"
        }
        return $true    
    })]
    [Alias('BeginBlock')]
    [ScriptBlock]
    $Begin,
    # The process block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if ($_.Ast.DynamicParamBlock -or $_.Ast.BeginBlock -or $_.Ast.ProcessBlock) {
            throw "ScriptBlock should not have any named blocks"
        }
        return $true    
    })]
    [ValidateScript({
        if ($_.Ast.ParamBlock.Parameters.Count) {
            throw "ScriptBlock should not have parameters"
        }
        return $true    
    })]
    [Alias('ProcessBlock')]
    [ScriptBlock]
    $Process,
    # The end block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if ($_.Ast.DynamicParamBlock -or $_.Ast.BeginBlock -or $_.Ast.ProcessBlock) {
            throw "ScriptBlock should not have any named blocks"
        }
        return $true    
    })]
    [ValidateScript({
        if ($_.Ast.ParamBlock.Parameters.Count) {
            throw "ScriptBlock should not have parameters"
        }
        return $true    
    })]
    [Alias('EndBlock')]
    [ScriptBlock]
    $End,
    
    # The script header.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Header
    )
    begin {
        $ParametersToCreate   = [Ordered]@{}
        $allDynamicParameters = @()
        $allBeginBlocks       = @()
        $allEndBlocks         = @()
        $allProcessBlocks     = @()
        $allHeaders           = @()      
    }
    process {
        if ($parameter) {
            # The -Parameter can be a dictionary of parameters.
            if ($Parameter -is [Collections.IDictionary]) {
                $parameterType = ''
                # If it is, walk thur each parameter in the dictionary
                foreach ($EachParameter in $Parameter.GetEnumerator()) {
                    # Continue past any parameters we already have
                    if ($ParametersToCreate.Contains($EachParameter.Key)) { 
                        continue
                    }
                    # If the parameter is a string and the value is not a variable
                    if ($EachParameter.Value -is [string] -and $EachParameter.Value -notlike '*$*') {
                        $parameterName = $EachParameter.Key
                        $ParametersToCreate[$EachParameter.Key] =
                            @(
                                $parameterAttribute = "[Parameter(ValueFromPipelineByPropertyName)]"
                                $parameterType
                                '$' + $parameterName
                            ) -ne ''
                    }
                    # If the value is a string and the value contains variables
                    elseif ($EachParameter.Value -is [string]) {
                        # embed it directly.
                        $ParametersToCreate[$EachParameter.Key] = $EachParameter.Value
                    }
                    # If the value is a ScriptBlock
                    elseif ($EachParameter.Value -is [ScriptBlock]) {
                        # Embed it
                        $ParametersToCreate[$EachParameter.Key] =
                            # If there was a param block on the script block
                            if ($EachParameter.Value.Ast.ParamBlock) {
                                # embed the parameter block (except for the param keyword)
                                $EachParameter.Value.Ast.ParamBlock.Extent.ToString() -replace 
                                    '^[\s\r\n]param(' -replace ')[\s\r\n]$'
                            } else {
                                # Otherwise
                                $EachParameter.Value.ToString() -replace 
                                    "\`$$($eachParameter.Key)[\s\r\n]$" -replace # Replace any trailing variables
                                    'param()[\s\r\n]{0,}$'  # then replace any empty param blocks.
                            }
                    }
                    elseif ($EachParameter.Value -is [Object[]]) {
                        $ParametersToCreate[$EachParameter.Key] =
                            $EachParameter.Value -join [Environment]::Newline
                    }
                }
            } elseif ($Parameter -is [string]) {
                $ParametersToCreate[$Parameter] = @(
                    "[Parameter(ValueFromPipelineByPropertyName)]"
                    "`$$Parameter"
                )
            } elseif ($Parameter -is [Object[]]) {
                $currentParam = @()
                $currentParamName = ''
                foreach ($EachParameter in $Parameter) {
                    if ($EachParameter -is [string] -and -not $EachParameter.Contains(' ')) {
                        if ($currentParam) {
                            $ParametersToCreate[$currentParamName] = $currentParam
                            $currentParam = @()
                            $currentParamName = ''
                        }
                        $currentParam += "`$$EachParameter"
                        $currentParamName = $EachParameter
                    } elseif ($EachParameter -is [string] -and $EachParameter.Contains(' ')) {
                        $currentParam = @(
                            if ($EachParameter.Contains("`n")) {
                                "<#" + [Environment]::newLine + $EachParameter + [Environment]::newLine + '#>'
                            } else {
                                "# $EachParameter"
                            }
                        ) + $currentParam
                    } elseif ($EachParameter -is [type]) {
                        $currentParam += "[$($EachParameter.Fullname)]"
                    }
                }
                if ($currentParamName) {
                    $ParametersToCreate[$currentParamName] = $currentParam
                }
            }
        }
        if ($header) {
            $allHeaders += $Header
        }
        if ($DynamicParameter) {
            $allDynamicParameters += $DynamicParameter
        }
        if ($Begin) {
            $allBeginBlocks += $begin
        }
        if ($process) {
            $allProcessBlocks += $process
        }
        if ($end) {
            $allEndBlocks += $end
        }
        
    }
    end {
        $newParamBlock = 
            "param(" + [Environment]::newLine + 
            $(@(foreach ($toCreate in $ParametersToCreate.GetEnumerator()) {
                $toCreate.Value -join [Environment]::NewLine
            }) -join (',' + [Environment]::NewLine)) +
            [Environment]::NewLine +
            ')'
        $createdScriptBlock = [scriptblock]::Create("
$($allHeaders -join [Environment]::Newline)
$newParamBlock
$(if ($allDynamicParameters) {
    @(@("dynamicParam {") + $allDynamicParameters + '}') -join [Environment]::Newline
})
$(if ($allBeginBlocks) {
    @(@("begin {") + $allBeginBlocks + '}') -join [Environment]::Newline
})
$(if ($allProcessBlocks) {
    @(@("process {") + $allProcessBlocks + '}') -join [Environment]::Newline
})
$(if ($allEndBlocks -and -not $allBeginBlocks -and -not $allProcessBlocks) {
    $allEndBlocks -join [Environment]::Newline
} elseif ($allEndBlocks) {
    @(@("end {") + $allEndBlocks + '}') -join [Environment]::Newline
})
")
        $createdScriptBlock
    }
}


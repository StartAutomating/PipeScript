function New-PipeScript
{
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
    # * As a ```[ScriptBlock]``` containing only parameters.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScriptBlock(ParameterOnly)]
    [ValidateTypes(TypeName={[Collections.IDictionary], [string],[Object[]], [Scriptblock]})]
    $Parameter,

    # The dynamic parameter block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScriptBlock(NoBlocks, NoParameters)]
    [Alias('DynamicParameterBlock')]
    [ScriptBlock]
    $DynamicParameter,

    # The begin block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScriptBlock(NoBlocks, NoParameters)]
    [Alias('BeginBlock')]
    [ScriptBlock]
    $Begin,

    # The process block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScriptBlock(NoBlocks, NoParameters)]
    [Alias('ProcessBlock')]
    [ScriptBlock]
    $Process,

    # The end block.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScriptBlock(NoBlocks, NoParameters)]
    [Alias('EndBlock')]
    [ScriptBlock]
    $End,

    # The script header.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Header
    )

    begin {
        $ParametersToCreate    = [Ordered]@{}
        $parameterScriptBlocks = @()
        $allDynamicParameters  = @()
        $allBeginBlocks        = @()
        $allEndBlocks          = @()
        $allProcessBlocks      = @()
        $allHeaders            = @()
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
                                    '^[\s\r\n]{0,}param\(' -replace '\)[\s\r\n]{0,}$'
                            } else {
                                # Otherwise
                                '[Parameter(ValueFromPipelineByPropertyName)]' + (
                                $EachParameter.Value.ToString() -replace
                                    "\`$$($eachParameter.Key)[\s\r\n]$" -replace # Replace any trailing variables
                                    'param\(\)[\s\r\n]{0,}$'  # then replace any empty param blocks.
                                )
                            }
                    }
                    # If the value was an array
                    elseif ($EachParameter.Value -is [Object[]]) {
                        $ParametersToCreate[$EachParameter.Key] = # join it's elements by newlines
                            $EachParameter.Value -join [Environment]::Newline
                    }
                }
            
            } 
            # If the parameter was a string
            elseif ($Parameter -is [string]) 
            {
                # treat it as  parameter name
                $ParametersToCreate[$Parameter] =                                         
                    @(
                    "[Parameter(ValueFromPipelineByPropertyName)]"
                    "`$$Parameter"
                    ) -join [Environment]::NewLine                    
            } 
            # If the parameter is a [ScriptBlock]
            elseif ($parameter -is [scriptblock]) 
            {
                
                # add it to a list of parameter script blocks.
                $parameterScriptBlocks +=
                    if ($parameter.Ast.ParamBlock) {                        
                        $parameter
                    }            
            }
        }

        # If there is header content,
        if ($header) {            
            $allHeaders += $Header
        }

        # dynamic parameters,
        if ($DynamicParameter) {            
            $allDynamicParameters += $DynamicParameter
        }

        # begin,
        if ($Begin) {            
            $allBeginBlocks += $begin
        }

        # process,
        if ($process) {            
            $allProcessBlocks += $process
        }

        # or end blocks.
        if ($end) {
            # accumulate them.
            $allEndBlocks += $end
        }

    }

    end {
        # Take all of the accumulated parameters and create a parameter block
        $newParamBlock =
            "param(" + [Environment]::newLine +
            $(@(foreach ($toCreate in $ParametersToCreate.GetEnumerator()) {
                $toCreate.Value -join [Environment]::NewLine
            }) -join (',' + [Environment]::NewLine)) +
            [Environment]::NewLine +
            ')'

        # If any parameters were passed in as ```[ScriptBlock]```s,
        if ($parameterScriptBlocks) {            
            $parameterScriptBlocks += [ScriptBlock]::Create($newParamBlock)
            # join them with the new parameter block.
            $newParamBlock = $parameterScriptBlocks | Join-PipeScript
        }

        # Create the script block by combining together the provided parts.
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

        # return the created script block.
        return $createdScriptBlock
    }
}

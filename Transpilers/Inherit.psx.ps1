<#
.SYNOPSIS
    Inherits a Command
.DESCRIPTION
    Inherits a given command.  
    
    This acts similarily to inheritance in Object Oriented programming.

    By default, inheriting a function will join the contents of that function with the -ScriptBlock.

    Your ScriptBlock will come first, so you can override any of the behavior of the underlying command.    

    You can "abstractly" inherit a command, that is, inherit only the command's parameters.
    
    Inheritance can also be -Abstract.
    
    When you use Abstract inheritance, you get only the function definition and header from the inherited command.

    You can also -Override the command you are inheriting.

    This will add an [Alias()] attribute containing the original command name.

    One interesting example is overriding an application


.EXAMPLE
    Invoke-PipeScript {
        [inherit("Get-Command")]
        param()
    } 
.EXAMPLE
    {
        [inherit("gh",Overload)]
        param()
        begin { "ABOUT TO CALL GH"}
        end { "JUST CALLED GH" }
    }.Transpile()
.EXAMPLE
    # Inherit Get-Transpiler abstractly and make it output the parameters passed in.
    {
        [inherit("Get-Transpiler", Abstract)]
        param() process { $psBoundParameters }
    }.Transpile()
.EXAMPLE
    {
        [inherit("Get-Transpiler", Dynamic, Abstract)]
        param()
    } | .>PipeScript
#>
param(
[Parameter(Mandatory,Position=0)]
[string]
$Command,

# If provided, will abstractly inherit a function.
# This include the function's parameters, but not it's content
# It will also define a variable within a dynamicParam {} block that contains the base command.
[switch]
$Abstract,

# If provided, will set an alias on the function to replace the original command.
[Alias('Overload')]
[switch]
$Override,

# If set, will dynamic overload commands.
# This will use dynamic parameters instead of static parameters, and will use a proxy command to invoke the inherited command.
[switch]
$Dynamic,

# If set, will always inherit commands as proxy commands.
# This is implied by -Dynamic.
[switch]
$Proxy,

# The Command Type.  This can allow you to specify the type of command you are overloading.
# If the -CommandType includes aliases, and another command is also found, that command will be used.
# (this ensures you can continue to overload commands)
[Alias('CommandTypes')]
[string[]]
$CommandType = 'All',

# A list of block types to be excluded during a merge of script blocks.
# By default, no blocks will be excluded.
[ValidateSet('using', 'requires', 'help','header','param','dynamicParam','begin','process','end')]
[Alias('SkipBlockType','SkipBlockTypes','ExcludeBlockTypes')]
[string[]]
$ExcludeBlockType,

# A list of block types to include during a merge of script blocks.
[ValidateSet('using', 'requires', 'help','header','param','dynamicParam','begin','process','end')]
[Alias('BlockType','BlockTypes','IncludeBlockTypes')]
[string[]]
$IncludeBlockType = @('using', 'requires', 'help','header','param','dynamicParam','begin','process','end'),

# A list of parameters to include.  Can contain wildcards.
# If -IncludeParameter is provided without -ExcludeParameter, all other parameters will be excluded.
[string[]]
$IncludeParameter,

# A list of parameters to exclude.  Can contain wildcards.
# Excluded parameters with default values will declare the default value at the beginnning of the command.
[string[]]
$ExcludeParameter,

[Parameter(ValueFromPipeline,ParameterSetName='ScriptBlock')]
[scriptblock]
$ScriptBlock = {}
)

process {
    # To start off with, let's resolve the command we're inheriting.
    $commandTypes    = [Management.Automation.CommandTypes]$($CommandType -join ',')
    $resolvedCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($Command, $commandTypes)
    # If it is an alias
    if ($resolvedCommand -is [Management.Automation.AliasInfo]) {
        # check for other commands by this name
        $otherCommandExists = $ExecutionContext.SessionState.InvokeCommand.GetCommand($Command, 
            $commandTypes -bxor ([Management.Automation.CommandTypes]'Alias'))
        if ($otherCommandExists) {
            # and use those instead (otherwise, a command can only be overloaded once).
            Write-Verbose "Using $otherCommandExists instead of alias"
            $resolvedCommand = $otherCommandExists
        }
    }
    
    # If we could not resolve the command
    if (-not $resolvedCommand) {
        Write-Error "Could not resolve -Command '$Command'" # error out.
        return
    }

    # Prepare parameters for Join-ScriptBlock
    $joinSplat = @{}
    foreach ($key in 'IncludeBlockType', 'ExcludeBlockType','IncludeParameter', 'ExcludeParameter') {
        if ($PSBoundParameters[$key]) {
            $joinSplat[$key] = $PSBoundParameters[$key]
        }    
    }

    # and determine the name of the command as a variable
    $commandVariable = $Command -replace '\W'

    # If -Dynamic was passed
    if ($Dynamic) {
        $Proxy = $true # it implies -Proxy.
    }

    # Now we get the script block that we're going to inherit.
$resolvedScriptBlock =
    # If we're inheriting an application
    if ($resolvedCommand -is [Management.Automation.ApplicationInfo]) {
        # make a light wrapper for it.
        [scriptblock]::Create(@"
param(
[Parameter(ValueFromRemainingArguments)]
[string[]]
`$ArgumentList
)

process {
    & `$baseCommand @ArgumentList
}
"@)    
    } elseif ($resolvedCommand -is [Management.Automation.CmdletInfo] -or $Proxy) {
        # If we're inheriting a Cmdlet or -Proxy was passed, inherit from a proxy command.
        .>ProxyCommand -CommandName $Command
    } 
    elseif (
        $resolvedCommand -is [Management.Automation.FunctionInfo] -or
        $resolvedCommand -is [management.Automation.ExternalScriptInfo]
    ) {
        # Otherwise, inherit the command's contents.
        $resolvedCommand.ScriptBlock
    }

    # Now we're passing a series of script blocks to Join-PipeScript

$(
    # If we do not have a resolved command, 
    if (-not $resolvedCommand) {
        {} # the first script block is empty.
    } else {
        # If we have a resolvedCommand, fully qualify it.
        $fullyQualifiedCommand = 
            if ($resolvedCommand.Module) {
                "$($resolvedCommand.Module)\$command"
            } else {
                "$command"
            }

        # Then create a dynamicParam block that will set `$baseCommand,
        # as well as a `$script: scoped variable for the command name.

[scriptblock]::create(@"
dynamicParam {
    `$baseCommand = 
        if (-not `$script:$commandVariable) {
            `$script:$commandVariable = 
                `$executionContext.SessionState.InvokeCommand.GetCommand('$($command -replace "'", "''")','$($resolvedCommand.CommandType)')
            `$script:$commandVariable
        } else {
            `$script:$commandVariable
        }
    $(
    # Embed -IncludeParameter
    if ($IncludeParameter) {
    "`$IncludeParameter = '$($IncludeParameter -join "','")'"
    } else {
    "`$IncludeParameter = @()"
    })
    $(
    # Embed -ExcludeParameter
    if ($ExcludeParameter) {
    "`$ExcludeParameter = '$($ExcludeParameter -join "','")'"
    }
    else {
    "`$ExcludeParameter = @()"
    })
}
"@)
    }
),  
    # Next is our [ScriptBlock].  This will come before almost everything else.
    $scriptBlock, 
    $(
    # If we are -Overriding, create an [Alias]
    if ($Override) {
        [ScriptBlock]::create("[Alias('$($command)')]param()")
    } else {
        {}
    }
),$(
    # Now we include the resolved script
    if ($Abstract -or $Dynamic) {
        # If we're using -Abstract or -Dynamic, we will strip out a few blocks first. 
        $excludeFromInherited = 'begin','process', 'end'
        if ($Dynamic) { 
            if (-not $Abstract) {
                $excludeFromInherited = 'param'
            } else {
                $excludeFromInherited += 'param'
            }
        }
        $resolvedScriptBlock | Join-PipeScript -ExcludeBlockType $excludeFromInherited
    } else {
        # otherwise, we embed the script as-is.
        $resolvedScriptBlock
    }
), $(
    if ($Dynamic) {        
        # If -Dynamic was passed, generate dynamic parameters.
{
    
dynamicParam {
    $DynamicParameters = [Management.Automation.RuntimeDefinedParameterDictionary]::new()            
    :nextInputParameter foreach ($paramName in ([Management.Automation.CommandMetaData]$baseCommand).Parameters.Keys) {
        if ($ExcludeParameter) {
            foreach ($exclude in $ExcludeParameter) {
                if ($paramName -like $exclude) { continue nextInputParameter}
            }
        }
        if ($IncludeParameter) {
            $shouldInclude = 
                foreach ($include in $IncludeParameter) {
                    if ($paramName -like $include) { $true;break}
                }
            if (-not $shouldInclude) { continue nextInputParameter }
        }
        
        $DynamicParameters.Add($paramName, [Management.Automation.RuntimeDefinedParameter]::new(
            $baseCommand.Parameters[$paramName].Name,
            $baseCommand.Parameters[$paramName].ParameterType,
            $baseCommand.Parameters[$paramName].Attributes
        ))
    }
    $DynamicParameters
}
}        
    } else {
        {}
    }
) |
    Join-PipeScript @joinSplat # join the scripts together and return one [ScriptBlock]


}




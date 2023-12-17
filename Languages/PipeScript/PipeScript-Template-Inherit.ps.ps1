Template function Inherit {
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
[Alias('Inherit','Inherits')]
param(
# The command that will be inherited.
[Parameter(Mandatory,Position=0)]
[Alias('CommandName')]
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

# If set, will not generate a dynamic parameter block.  This is primarily present so Abstract inheritance has a small change footprint. 
[switch]
$NoDynamic,

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

# The ArgumentList parameter name
# When inheriting an application, a parameter is created to accept any remaining arguments.
# This is the name of that parameter (by default, 'ArgumentList')
# This parameter is ignored when inheriting from anything other than an application.
[Alias('ArgumentListParameter')]
[string]
$ArgumentListParameterName = 'ArgumentList',

# The ArgumentList parameter aliases
# When inheriting an application, a parameter is created to accept any remaining arguments.
# These are the aliases for that parameter (by default, 'Arguments' and 'Args')
# This parameter is ignored when inheriting from anything other than an application.
[Alias('ArgumentListParameters','ArgumentListParameterNames')]
[string[]]
$ArgumentListParameterAlias = @('Arguments', 'Args'),

# The ArgumentList parameter type
# When inheriting an application, a parameter is created to accept any remaining arguments.
# This is the type of that parameter (by default, '[string[]]')
# This parameter is ignored when inheriting from anything other than an application.
[type]
$ArgumentListParameterType = [string[]],

# The help for the argument list parameter.
# When inheriting an application, a parameter is created to accept any remaining arguments.
# This is the help of that parameter (by default, 'Arguments to $($InhertedApplication.Name)')
# This parameter is ignored when inheriting from anything other than an application.
[Alias('ArgumentListParameterDescription')]
[string]
$ArgumentListParameterHelp = 'Arguments to $($InhertedApplication.Name)',

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
    foreach ($key in 'IncludeBlockType', 'ExcludeBlockType') {
        if ($PSBoundParameters[$key]) {
            $joinSplat[$key] = $PSBoundParameters[$key]
        }    
    }

    $joinInheritedSplat = @{}
    foreach ($key in 'IncludeParameter', 'ExcludeParameter') {
        if ($PSBoundParameters[$key]) {
            $joinInheritedSplat[$key] = $PSBoundParameters[$key]
        }    
    }

    # and determine the name of the command as a variable
    $commandVariable = $Command -replace '\W'

    # If -Dynamic was passed
    if ($Dynamic) {
        $Proxy = $true # it implies -Proxy.
    }

    $InhertedApplication = 
        if ($resolvedCommand -is [Management.Automation.ApplicationInfo]) {
            $resolvedCommand
        }
        elseif (
            $resolvedCommand -is [Management.Automation.AliasInfo] -and 
            $resolvedCommand.ResolvedCommand -is [Management.Automation.ApplicationInfo]
        ) {
            $resolvedCommand.ResolvedCommand
        }

    if ($InhertedApplication) {
        # In a couple of cases, we're inheriting an application.
        # In this scenario, we want to use the same wrapper [ScriptBlock]
        $paramHelp = 
            foreach ($helpLine in $ExecutionContext.SessionState.InvokeCommand.ExpandString($ArgumentListParameterHelp) -split '(?>\r\n|\n)') {
                "# $HelpLine"
            }

        $applicationWrapper = New-PipeScript -Parameter @{
            $ArgumentListParameterName = @(                
                $paramHelp
                "[Parameter(ValueFromRemainingArguments)]"                
                "[Alias('$($ArgumentListParameterAlias -join "','")')]"
                "[$ArgumentListParameterType]"
                "`$$ArgumentListParameterName"
            )
        } -Process {
            & $baseCommand @ArgumentList
        }     
    }
    

    # Now we get the script block that we're going to inherit.
    $resolvedScriptBlock =
        # If we're inheriting an application
        if ($resolvedCommand -is [Management.Automation.ApplicationInfo]) {
            # use our light wrapper.
            $applicationWrapper
        } elseif ($resolvedCommand -is [Management.Automation.CmdletInfo] -or $Proxy) {
            # If we're inheriting a Cmdlet or -Proxy was passed, inherit from a proxy command.
            .>ProxyCommand -CommandName $Command
        } 
        elseif (
            # If it's a function or script
            $resolvedCommand -is [Management.Automation.FunctionInfo] -or
            $resolvedCommand -is [management.Automation.ExternalScriptInfo]
        ) {
            # inherit from the ScriptBlock definition.
            $resolvedCommand.ScriptBlock
        }
        elseif (
            # If we're inheriting an alias to something with a scriptblock
            $resolvedCommand -is [Management.Automation.AliasInfo] -and 
            $resolvedCommand.ResolvedCommand.ScriptBlock) {
            
            # inherit from that ScriptBlock.
            $resolvedCommand.ResolvedCommand.ScriptBlock
        }
        elseif (
            # And if we're inheriting from an alias that points to an application
            $resolvedCommand -is [Management.Automation.AliasInfo] -and
            $resolvedCommand.ResolvedCommand -is [Management.Automation.ApplicationInfo]) {
            # use our lite wrapper once more.
            $applicationWrapper
        }

    if (-not $resolvedCommand) {
        Write-Error "Could not resolve [ScriptBlock] to inheirt from Command: '$Command'"
        return
    }
    # Now we're passing a series of script blocks to Join-PipeScript

$(
    # If we do not have a resolved command, 
    if (-not $resolvedCommand) {
        {} # the first script block is empty.
    }     
    else {
        # If we have a resolvedCommand, fully qualify it.
        $fullyQualifiedCommand = 
            if ($resolvedCommand.Module) {
                "$($resolvedCommand.Module)\$command"
            } else {
                "$command"
            }

        # Then create a dynamicParam block that will set `$baseCommand,
        # as well as a `$script: scoped variable for the command name.         
        if ($NotDynamic) # unless, of course -NotDynamic is passed
        {
            {}
        } else
        {
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
        $excludeFromInherited = 'begin','process', 'end', 'header','help'
        if ($Dynamic) { 
            if (-not $Abstract) {
                $excludeFromInherited = 'param'
            } else {
                $excludeFromInherited += 'param'
            }
        }
        $resolvedScriptBlock | Join-PipeScript -ExcludeBlockType $excludeFromInherited @joinInheritedSplat
    } else {        
        
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
}

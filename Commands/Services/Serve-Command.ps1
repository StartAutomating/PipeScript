
function Serve.Command {

    <#
    .SYNOPSIS
        Serves a command.
    .DESCRIPTION
        Serves a command or pattern of commands.
    #>
    [ValidatePattern(        
        '
        /
        (?>
            $($this.Command)
        |
            $($this.Command -split "\p{P}" -join "/")
        |
            $(
                $CmdParts = $this.Command -split "\p{P}"
                [Array]::Reverse($cmdParts)
                $cmdParts -join "/"
            )
        )
        /?
        ', Options ='IgnoreCase,IgnorePatternWhitespace'
    )]
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The command or pattern of commands that is being served.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('CommandPattern')]
    [PSObject]
    $Command,

    # The request object.
    # This should generally not be provided, as it will be provided by the server.
    # (it can be provided for testing purposes)
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $Request,

    # A collection of parameters to pass to the command.  
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters')]
    [PSObject]
    $Parameter,

    # A collection of parameters to pass to the command by default, if no parameter was provided.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('DefaultParameters')]
    [PSObject]
    $DefaultParameter,    
    
    # One or more parameters to remove.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('HideParameter','DenyParameter','DenyParameters')]
    [string[]]
    $RemoveParameter,
        
    # The displayed name of the command
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Title','DisplayName')]
    [string]
    $Name
    )

    process {
        $ServingTheseCommands = 
            if ($Command -is [string]) {
                $ExecutionContext.SessionState.InvokeCommand.GetCommands('*', 'Function,Alias,Cmdlet', $true) -match $Command
            } elseif ($Command -is [Management.Automation.CommandInfo]) {
                $Command
            } elseif ($Command -is [ScriptBlock]) {
                $function:InnerServiceFunction = $Command
                $ExecutionContext.SessionState.InvokeCommand.GetCommand('InnerServiceFunction','Function')
                $Command
            }

        if (-not $ServingTheseCommands) { return }        

        $CombinedParameters = [Ordered]@{}
        
        if ($RemoveParameter) {
            foreach ($prop in $RemoveParameter) {
                $CombinedParameters.Remove($prop)
            }
        }

        if ($DefaultParameter) {
            if ($DefaultParameter -is [Collections.IDictionary]) {
                $DefaultParameter = [PSCustomObject]$DefaultParameter
            }
            foreach ($prop in $DefaultParameter.psobject.properties) {
                $CombinedParameters[$prop.Name] = $prop.Value
            }
        }

        if ($Parameter) {
            if ($Parameter -is [Collections.IDictionary]) {
                $Parameter = [PSCustomObject]$Parameter
            }
            foreach ($prop in $Parameter.psobject.properties) {
                $CombinedParameters[$prop.Name] = $prop.Value
            }
        }


        if ($Request) {            
            $requestParameter = if ($Request.Params) {
                $Request.Params
            } elseif ($Request.Body) {
                $Request.Body
            }
            if ($RequestParameter -is [Collections.IDictionary]) {
                $RequestParameter = [PSCustomObject]$RequestParameter
            }
            foreach ($prop in $RequestParameter.psobject.properties) {
                if ($RemoveParameter -contains $prop.Name) { continue }
                $CombinedParameters[$prop.Name] = $prop.Value
            }
        }
        
        @(foreach ($NowServingCommand in $ServingTheseCommands) {            
            $nowServingCommandParameters = $NowServingCommand.CouldRun($CombinedParameters)
            if ($nowServingCommandParameters) {
                . {
                    & $NowServingCommand @nowServingCommandParameters
                    trap {
                        [PSCustomObject][Ordered]@{
                                                    PSTypeName = 'Service.Error'
                                                    CommandName = $NowServingCommand.Name
                                                    RequestParameters = $RequestParameter
                                                    Error = $_
                                                }
                    }
                }                
            } else {
                [PSCustomObject][Ordered]@{
                                    PSTypeName = 'Service.MissingParameter'
                                    CommandName = $NowServingCommand.Name
                                    RequestParameters = $RequestParameter
                                }
            }
        })
    }

}



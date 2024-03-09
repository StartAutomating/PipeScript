[ValidatePattern('ProxyCommand')]
param()


function Template.PipeScript.ProxyCommand {

    <#
    .SYNOPSIS
        Creates Proxy Commands
    .DESCRIPTION
        Generates a Proxy Command for an underlying PowerShell or PipeScript command.
    .EXAMPLE
        {
            function [ProxyCommand<'Get-Process'>]GetProcessProxy {}
        } | .>PipeScript
    .EXAMPLE
        ProxyCommand -CommandName Get-Process -RemoveParameter *
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {[ProxyCommand('Get-Process')]param()}
    .EXAMPLE
        Invoke-PipeScript -ScriptBlock {
            [ProxyCommand('Get-Process', 
                RemoveParameter='*',
                DefaultParameter={
                    @{id='$pid'}
                })]
                param()
        }
    .EXAMPLE
        { 
            function Get-MyProcess {
                [ProxyCommand('Get-Process', 
                    RemoveParameter='*',
                    DefaultParameter={
                        @{id='$pid'}
                    })]
                    param()
            } 
        } | .>PipeScript
    #>
    [Alias('ProxyCommand')]
    param(
    # The ScriptBlock that will become a proxy command.  This should be empty, since it is ignored.
    [Parameter(ValueFromPipeline)]
    [scriptblock]
    $ScriptBlock,

    # The name of the command being proxied.
    [Parameter(Mandatory,Position=0)]
    [string]
    $CommandName,

    # If provided, will remove any number of parameters from the proxy command.
    [string[]]
    $RemoveParameter,

    # Any default parameters for the ProxyCommand.
    [Collections.IDictionary]
    $DefaultParameter
    )

    process {

        $resolvedCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Alias,Function,Cmdlet')
        if (-not $resolvedCommand) {
            Write-Error "Could not resolve -CommandName '$CommandName'"
            return
        }

        $commandMetadata = [Management.Automation.CommandMetadata]$resolvedCommand

        if ($RemoveParameter) {    
            $toRemove = @(
                foreach ($paramName in $commandMetadata.Parameters.Keys) {
                    if ($RemoveParameter -contains $paramName) {
                        $paramName
                    } else {
                        foreach ($rp in $RemoveParameter) {
                            if ($paramName -like $rp) {
                                $paramName
                                break
                            }
                        }
                    }
                }
            )

            $null = foreach ($tr in $toRemove) {
                $commandMetadata.Parameters.Remove($tr)
            }
        }

        $proxyCommandText = [Management.Automation.ProxyCommand]::Create($commandMetadata)

        if ($DefaultParameter) {
            $toSplat = "@'
$(ConvertTo-Json $DefaultParameter -Depth 100)
'@"
        $insertPoint = $proxyCommandText.IndexOf('$scriptCmd = {& $wrappedCmd @PSBoundParameters }')
        $proxyCommandText = $proxyCommandText.Insert($insertPoint,@"
        `$_DefaultParameters = ConvertFrom-Json $toSplat                
        foreach (`$property in `$_DefaultParameters.psobject.properties) {
            `$psBoundParameters[`$property.Name] = `$property.Value
            if (`$property.Value -is [string] -and `$property.Value.StartsWith('`$')) {
                `$psBoundParameters[`$property.Name] = `$executionContext.SessionState.PSVariable.Get(`$property.Value.Substring(1)).Value
            }
        }
"@)

        }

        [ScriptBlock]::Create($proxyCommandText)
    }

}


[ValidatePattern('Module')]
param()

Serve function Module {
    <#
    .SYNOPSIS
        Serves a Module
    .DESCRIPTION
        Services a request to a module.

        This should first attempt to call any of the module's routes,
        Then attempt to find an appropriate topic.
        Then return the default module topic.
    #>    
    param(
    # The module being served
    [vfp(Mandatory)]
    [psmoduleinfo]
    $Module,

    # The request object.
    # This should generally not be provided, as it will be provided by the server.
    # (it can be provided for testing purposes)
    [vbn()]
    [PSObject]
    $Request
    )
    
    process {
        $nowServingModule = $Module

        $NowServingModuleRoutes = $NowServingModule.Route
        $MyParameters = [Ordered]@{} + $PSBoundParameters
         
        $ServedARoute = $false
        :ServicingRoutes foreach ($nowServingRoute in $NowServingModuleRoutes) {
            $ShouldServeThisUrl = $nowServingRoute.ForUrl($request.Url)
            if ($ShouldServeThisUrl) {
                $ServedARoute = $true
            }
            if ($ShouldServeThisUrl -is [ScriptBlock]) {
                . $ShouldServeThisUrl
            } elseif ($ShouldServeThisUrl -is [Management.Automation.CommandInfo]) {
                . $ShouldServeThisUrl
            } elseif ($ShouldServeThisUrl.pstypenames -contains 'PipeScript.Module.Service') {                
                foreach ($serviceParameterSet in $ShouldServeThisUrl.GetServiceParameters()) {
                    $serviceCommand = $serviceParameterSet.Command
                    if ($serviceCommand) {
                        $serviceParameterCopy = [Ordered]@{} + $serviceParameterSet
                        foreach ($parameterName in $MyParameters.Keys) {
                            if ($serviceCommand.Parameters[$parameterName] -and 
                                -not $serviceParameterCopy[$parameterName]
                            ) {
                                $serviceParameterCopy[$parameterName] = $MyParameters[$parameterName]
                            }
                        }   
                        . $serviceCommand @serviceParameterCopy
                    }
                }
            }
        }

        return if $ServedARoute        


        $potentialTopicName = $Request.Url.Segments -replace '^/' -ne ''  -join ' '
        if ($potentialTopicName) {
            $module.Topics.Get($potentialTopicName)
        } else {
            $module.Topics.Get($module.Name)
        }
        
    }
}
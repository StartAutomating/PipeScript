<#
.SYNOPSIS
    Starts PipeScript as a HTTP Server.
.DESCRIPTION
    Starts PipeScript as a HTTP server inside of a background job, then waits forever.
.NOTES
    There are many ways you can route requests with PipeScript and PSNode.

    This is a functional example of many of them at play.
#>
param()
Push-Location $PSScriptRoot
$ImportedModules = Get-ChildItem -Path /Modules -Directory |
    ForEach-Object { Import-Module $_.FullName -Global -Force -PassThru }


# Requests can be routed by piping into PSNode, which will start multiple PSNode jobs.
# Note that only one request can exist for a given host name, port, and path.
& {
    [PSCustomObject]@{
        # So if we bind to every request coming in from every server, we can only have one job. 
        Route = "http://*:80/" 
        
        Command = {
            $Url = $request.Url



            # Of course, a job can have modules loaded, and 
            $NowServingModule = $null
            # all loaded modules can have one or more .Server(s) associated with them.
            # If there is a server for a module, we want to defer to that.
            :FindingTheModuleForThisServer foreach ($loadedModule in Get-Module) {
                if ($loadedModule.Server) {
                    foreach ($loadedModuleServer in $loadedModule.Server) {
                        if ($loadedModuleServer -isnot [string]) {continue }
                        if ($request.Url.Host -like $loadedModuleServer) {
                            $NowServingModule = $loadedModule
                            break FindingTheModuleForThisServer
                        }
                    }
                }
            }

            if ($NowServingModule) {
                # If a module has a [ScriptBlock] value in it's server list, we can use this to respond
                # (manifests cannot declare a [ScriptBlock], it would have to be added during or after module load)
                foreach ($moduleServer in $NowServingModule) {                    
                    if ($moduleServer -is [ScriptBlock]) {
                        return . $moduleServer
                    }
                }

                # We can also serve up module responses using events.
                
                # Each web request already basically is an event, we just need to broadcast it
                $NowServingMessage = ([PSCustomObject]([Ordered]@{RequestGUID=[GUID]::newguid().ToString()} + $psBoundParameters))                
                $ServerEvent   = New-Event -SourceIdentifier "$NowServingModule.$($request.URL.Scheme).Request" -Sender $NowServingModule -EventArguments $NowServingMessage -MessageData $NowServingMessage
                Start-Sleep -Milliseconds 1 # and then wait a literal millisecond so the server can respond (the response can take more than a millisecond, the timeout cannot).
                # Get all of the events
                $responseEvents = @(Get-Event -SourceIdentifier "$NowServingModule.$($request.URL.Scheme).Response.$($NowServingMessage.RequestGUID)" -ErrorAction Ignore)
                [Array]::Reverse($responseEvents) # and flip the order
                $responseEvent = $responseEvents[0] # so we get the most recent response.

                # There are three forms of message data we'll consider a response:
                # * If the message data is now a string
                $NowServingResponse = $(if ($responseEvent.MessageData -is [string]) {
                    $responseEvent.MessageData
                }
                # * If the message data has an .Answer
                elseif ($responseEvent.MessageData.Answer) 
                {
                    $responseEvent.MessageData.Answer
                } 
                # * If the message data has a .Response.
                elseif ($responseEvent.MessageData.Response) {
                    $responseEvent.MessageData.Response
                })
                # $ServerEvent              
                $responseEvents | Remove-Event -ErrorAction Ignore # Remove the event to reclaim memory and keep things safe.
                
                return $nowServingResponse # return whatever response we got (or nothing)
            }


            # Last but not least, we can do things the "old-fashioned" way and handle the request directly.
            
            # We can easily use a switch statement to route by host
            :RouteHost switch ($Url.Host) {
                'pipescript.test' {
                    "hello world" # Of course, this would get a little tedious and inflexible to do for each server
                }                 
                default {                    

                    # Another way we can route is by doing a regex based switch on the url.  This can be _very_ flexible
                    :RouteUrl switch -Regex ($url) {
                        
                        default {
                            # By default, we still want to look for any route commands we know about
                            $pipescriptRoutes = Get-PipeScript -PipeScriptType Route
                            
                            # If we have any routes,
                            $mappedRoute = foreach ($psRoute in $pipescriptRoutes) {
                                # we want to ensure they're valid, given this URL
                                if (-not $psRoute.Validate($request.Url)) {
                                    continue
                                }
                            
                                # In this server, there can be only one valid route
                                $psRoute
                                break
                            }  
                                               
                            # If we've mapped to a single valid route
                            if ($mappedRoute) {
                                . $mappedRoute # run that
                            } else {
                                # Otherwise, show the PipeScript logo
                                Get-Content (
                                    Get-Module PipeScript | 
                                    Split-Path | 
                                    Join-Path -ChildPath Assets | 
                                    Join-Path -ChildPath PipeScript-4-chevron-animated.svg
                                ) -Raw
                            }
                        }
                    }
                }
            }                         
        }
        ImportModule = $ImportedModules
    }
} | 
    Start-PSNode | Out-Host

# Now we enter an infinite loop where we let the jobs do their work
while ($true) {
    $ev = $null
    $results = Get-Job | Receive-Job -errorVariable ev *>&1
    if ($ev) {
        $ev | Out-String
        break
    }
    
    Start-Sleep -Seconds 5
}

Pop-Location

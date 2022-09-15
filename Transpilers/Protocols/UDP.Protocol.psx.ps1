using namespace System.Management.Automation.Language;
<#
.SYNOPSIS
    udp protocol
.DESCRIPTION
    Converts a UDP protocol command to PowerShell
.EXAMPLE
    udp://127.0.0.1:8568  # Creates a UDP Client
.EXAMPLE
    udp:// -Host [ipaddress]::broadcast 911 -Send "It's an emergency!"
.EXAMPLE
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"}.Transpile()
.EXAMPLE
    Invoke-PipeScript { receive udp://*:911 } 

    Invoke-PipeScript { send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!" }

    Invoke-PipeScript { receive udp://*:911 -Keep } 
#>
[ValidateScript({
    $commandAst = $_    
    if ($commandAst.CommandElements[0..1] -match '^udp://' -ne $null) {
        return $true
    }
    return $false
})]
param(
# The URI.
[Parameter(Mandatory,ValueFromPipeline)]
[uri]
$CommandUri,

# The Command's Abstract Syntax Tree
[Parameter(Mandatory)]
[Management.Automation.Language.CommandAST]
$CommandAst
)

process {
    $commandParameters = [Ordered]@{} + $CommandAst.Parameter
    $commandArguments  = @() + $CommandAst.ArgumentList
    
    $methodName  = ''
    $commandName = 
        if ($CommandAst.CommandElements[0].Value -match '://') {
            $CommandAst.CommandElements[0].Value
        } elseif ($commandArguments.Length -ge 1 -and 
            $commandArguments[0] -is [string] -and 
            $commandArguments[0]  -match '://') {
            $methodName       = $CommandAst.CommandElements[0].Value
            $commandArguments[0]
            $commandArguments = $commandArguments[1..$($commandArguments.Count)]
        }

    $udpIP, $udpPort = $null, $null
    $constructorArgs = 
        @(if ($CommandUri.Host) {
            $udpIP = $commandUri.Host
            $commandUri.Host
            if ($commandUri.Port) {
                $udpPort = $CommandUri.Port
                $commandUri.Port
            }
        } elseif ($commandParameters.Port -and -not $commandParameters.Host) {
            $udpPort = $commandParameters.Port
            $commandParameters.Port
        } elseif ($commandParameters.Host -and $commandParameters.Port) {
            $udpIP   = $commandParameters.Host
            $udpIP
            $udpPort = $commandParameters.Port 
            $udpPort 
        })

    # We will always need to construct a client
    # so prepare that code now that we know the host and port.
    $constructUdp    = "new Net.Sockets.UdpClient $constructorArgs"

    
    if ($udpIP -is [string] -and $udpIP -notmatch '^\[') {            
        $udpIP = "'$($udpIP -replace "'", "''")'"
    }

    # If the method name is send or -Send was provided
    if ($methodName -eq 'send' -or $commandParameters.Send) {
        # ensure we have both and IP and a port
        if (-not $udpIP -or -not $udpPort) {
            Write-Error "Must provide both IP and port to send"
            return
        }

        # If we don't have a -Send parameter, try to bind positionally.
        if (-not $commandParameters.Send -and $commandArguments[0]) {
            $commandParameters.Send = $commandArguments[0]
        }

        # If we still don't have a -Send parameter, error out.
        if (-not $commandParameters.Send) {            
            Write-Error "Nothing to $(if ($methodName -ne 'Send') {'-'})Send"
            return
        }

        # prepare send to be embedded
        $embedSend = 
            if ($commandParameters.Send -is [ScriptBlock]) {
                "& {$($commandParameters.Send)}"
            } elseif ($commandParameters.Send -is [string]) {
                "[text.Encoding]::utf8.GetBytes('$($commandParameters.Send -replace "'","''")')"
            }
            else {
                $commandParameters.Send
            }
        # Create a UDP client and send the datagram.
[ScriptBlock]::Create("
`$udpClient = $constructUDP
`$datagram  = @($embedSend) -as [byte[]]
`$bytesSent = `$udpClient.Send(`$datagram, `$datagram.Length)
").Transpile()        
    }
    # If the method name is receive or -Receive was passed, we'll want to receive results
    elseif ($methodName -eq 'Receive' -or $commandParameters.Receive) 
    {
        # If -Receive was not passed, try to bind it positionally.
        if (-not $commandParameters.Receive) {
            $commandParameters.Receive = $commandArguments[0]
        }

        # If -Receive was passed and was not a [ScriptBlock], error out.
        if ($commandParameters.Receive -and $commandParameters.Receive -isnot [ScriptBlock]) {
            Write-Error "UDP -Receive must be a [ScriptBlock]"
            return
        }

        # If -Receive was not provided, default it to creating an event.
        if (-not $commandParameters.Receive) {
            $commandParameters.Receive = {    
    New-Event "$udpEventName" -MessageData $datagram
            }
        }
        
        # If we do not have an IP and port, we cannot receive.
        if (-not $udpIP -or -not $udpPort) {
            Write-Error "Must provide both IP and port to receive"
            return
        }

        # Receiving UDP results must be run in a background job.
        # Thus we start by creating that script.

        $jobScript = 
[ScriptBlock]::Create(@"
`$udpClient      = [Net.Sockets.UdpClient]::new()
`$udpEndpoint    = [Net.IpEndpoint]::new(
    ([ipaddress]$udpIP), $udpPort
)
`$udpEventName   = "udp://`$udpEndPoint"
Register-EngineEvent -SourceIdentifier `$udpEventName -Forward
`$udpClientBound = `$false
try {    
    `$udpClient.Client.Bind(`$udpEndpoint)
    `$udpClientBound = `$true
} catch  {
    Write-Error -Message `$_.Message -Exception `$_.Exception
}
:udpReceive while (`$udpClientBound) {
    `$datagram = `$udpClient.Receive([ref]`$udpEndpoint)
    & {
        $($commandParameters.Receive)
    } `$datagram
}
`$udpClient.Close()
"@).Transpile()
        # Now we construct the job name.        
        $jobName = "'${udpIP}:${udpPort}'" -replace "['`"]"
        # Then we set the jobCommand.
        # It would be nice to be able to use Start-ThreadJob, but Start-ThreadJob will not forward events.
        # (also, Starting a ThreadJob and then doing a blocking call on that thread makes a job that cannot be stopped)
        $jobCommand = "Start-Job "

        $outputScript = 
[ScriptBlock]::create(@"

`$jobName = '$jobName'
`$jobScript = {
    $jobScript
}
`$JobExists = Get-Job | Where-Object Name -eq `$JobName
if (-not (`$JobExists)) {
    $(
        if (-not $CommandAst.IsAssigned) {
            '$null = '
        }
    )$($jobCommand + '-Name "$jobName" -ScriptBlock $jobScript')
} else {
    `$JobExists | Receive-Job$(if ($commandParameters.Keep) { ' -Keep'})
}
"@)

        # If the command is assigned, wrap it in $() so that only one thing is returned.
        if ($CommandAst.IsAssigned) {
            [ScriptBlock]::create("`$($outputScript)")
        } else {
            $outputScript
        }        
    }
    else {
        [scriptblock]::Create($constructUdp).Transpile()
    }    
}

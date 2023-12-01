
function Protocol.UDP {


<#
.SYNOPSIS
    UDP protocol
.DESCRIPTION
    Converts a UDP protocol command to PowerShell.
.EXAMPLE
    # Creates the code to create a UDP Client
    {udp://127.0.0.1:8568} | Use-PipeScript  
.EXAMPLE
    # Creates the code to broadast a message.
    {udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"} | Use-PipeScript
.EXAMPLE
    {send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"} | Use-PipeScript
.EXAMPLE
    Use-PipeScript {
        watch udp://*:911
    
        send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"

        receive udp://*:911
    }    
#>
[ValidateScript({
    $commandAst = $_    
    if ($commandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
    if ($commandAst.CommandElements[0..1] -match '^udp://' -ne $null) {
        if ($commandAst.CommandElements[0] -notmatch '^udp://') {
            if ($commandAst.CommandElements[0].value -notin 'send', 'receive', 'watch') {
                return $false
            }
        }        
        return $true
    }

    return $false
})]
[Alias('UDP','UDP://')]
param(
# The URI.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='Protocol',Position=0)]
[Parameter(ValueFromPipeline,ParameterSetName='Interactive',Position=0)]
[Parameter(Mandatory,ParameterSetName='ScriptBlock',Position=0)]
[uri]
$CommandUri,

[ValidateSet('Send','Receive','Watch')]
[Parameter(Position=1)]
[string]
$Method,

# The Command's Abstract Syntax Tree
[Parameter(Mandatory,ParameterSetName='Protocol')]
[Management.Automation.Language.CommandAST]
$CommandAst,

# If the UDP protocol is used as an attribute, this will be the existing script block.
[Parameter(Mandatory,ParameterSetName='ScriptBlock')]
[ScriptBlock]
$ScriptBlock = {},

# The script or message sent via UDP.
$Send,

# If set, will receive result events.
[switch]
$Receive,

# A ScriptBlock used to watch the UDP socket. 
[scriptblock]
$Watch,

# The host name.  This can be provided via parameter if it is not present in the URI.
[Alias('Host')]
[string]
$HostName,

# The port.  This can be provided via parameter if it is not present in the URI.
[int]
$Port,

# Any remaining arguments.
[Parameter(ValueFromRemainingArguments)]
[PSObject[]]
$ArgumentList
)

process {
    $commandParameters = 
        if ($PSCmdlet.ParameterSetName -eq 'Protocol') {
            [Ordered]@{} + $CommandAst.Parameter
        }
        else {
            [Ordered]@{} + $PSBoundParameters
        }
        
    $commandArguments  = 
        if ($PSCmdlet.ParameterSetName -eq 'Protocol') {
            @() + $CommandAst.ArgumentList
        }
        else {
            @() + $args
        }

    if (-not $CommandUri.Scheme) {
        $commandUri = [uri]"udp://$($commandUri.OriginalString -replace '://')"
    }
        
    $methodName  = $Method    

    $udpIP, $udpPort = $null, $null
    $constructorArgs = 
        
        @(
        if ($CommandUri.Host) {
            $udpIP = $commandUri.Host
            $commandUri.Host
            if ($commandUri.Port) {
                $udpPort = $CommandUri.Port
                $commandUri.Port
            }
        } 
        elseif ($commandParameters.Port -and -not ($commandParameters.Host -or $commandParameters.HostName)) {
            $udpPort = $commandParameters.Port
            $commandParameters.Port
        } 
        elseif (($commandParameters.Host -or $commandParameters.HostName) -and $commandParameters.Port) {
            $udpIP   = if ($commandParameters.Host) {
                $commandParameters.Host
            } else {
                $commandParameters.HostName
            }
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

    $UdpOperationScript = 

    # If the method name is send or -Send was provided
    if ($methodName -eq 'send' -or $commandParameters.Send) {
        # ensure we have both and IP and a port
        if (-not $udpIP -or -not $udpPort) {
            Write-Error "Must provide both IP and port to send"
            return
        }

        # If we don't have a -Send parameter, try to bind positionally.
        if (-not $commandParameters.Send -and $commandArguments -and $commandArguments[0]) {
            $commandParameters.Send = $commandArguments[0]
        } elseif (-not $commandParameters.Send -and $argumentList -and $ArgumentList[0]) {
            $commandParameters.Send = $ArgumentList[0]
        }

        # If we still don't have a -Send parameter, error out.
        if (-not $commandParameters.Send) {            
            Write-Verbose "Nothing to $(if ($methodName -ne 'Send') {'-'} else {"Send"})"
            return
        }

        # prepare send to be embedded
        $embedSend = 
            if ($commandParameters.Send -is [ScriptBlock]) {
                "& {$($commandParameters.Send)}"
            } elseif ($commandParameters.Send -is [string]) {
                "[text.Encoding]::utf8.GetBytes('$($commandParameters.Send -replace "'","''")')"
            }
            elseif ($commandParameters.Send -as [byte[]]) {
                "[Convert]::FromBase64String('$([Convert]::ToBase64String($commandParameters.Send))')"
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
    # If the method name is Watch or -Watch was passed, we'll want to watch for results
    elseif ($methodName -eq 'Watch' -or $commandParameters.Watch) 
    {
        # If -Watch was not passed, try to bind it positionally.
        if (-not $commandParameters.Watch) {
            $commandParameters.Watch = $commandArguments[0]
        }

        # If -Watch was passed and was not a [ScriptBlock], unset it.
        if ($commandParameters.Watch -and $commandParameters.Watch -isnot [ScriptBlock]) {
            $commandParameters.Watch = $null            
        }

        # If -Watch was not provided, default it to creating an event.
        if (-not $commandParameters.Watch) {
            $commandParameters.Watch = {    
    New-Event "$udpEventName" -MessageData $datagram
            }
        }
        
        # If we do not have an IP and port, we cannot watch.
        if (-not $udpIP -or -not $udpPort) {
            Write-Error "Must provide both IP and port to Watch"
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
    `$watchOutput = & {
        $($commandParameters.Watch)
    } `$datagram

    if (`$watchOutput -isnot [Management.Automation.PSEvent]) {
        New-Event -SourceIdentifier `$udpEventName -MessageData `$watchOutput
    }
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
if ((-not `$JobExists) -or (`$jobExists.State -ne 'Running')) {
    $(
        if (-not $CommandAst.IsAssigned) {
            '$null = '
        }
    )$($jobCommand + '-Name "$jobName" -ScriptBlock $jobScript')
}
"@)

        # If the command is assigned, wrap it in $() so that only one thing is returned.
        if ($CommandAst.IsAssigned) {
            [ScriptBlock]::create("`$($outputScript)")
        } else {
            $outputScript
        }        
    }
    elseif ($methodName -eq 'Receive' -or $commandParameters.Receive) {
        $jobName = "${udpIP}:${udpPort}" -replace "['`"]"
        $eventName = "udp://${udpIP}:${udpPort}" -replace "['`"]"        
        [scriptblock]::Create("
`$(
`$udpEvents = 
    @(Get-Event -SourceIdentifier '$eventName' -ErrorAction Ignore)
[Array]::Reverse(`$udpEvents)
`$udpEvents
)
")
        
    }
    else {
        [scriptblock]::Create($constructUdp).Transpile()
    }
    
    switch ($PSCmdlet.ParameterSetName) {
        Protocol {
            $UdpOperationScript
        }
        ScriptBlock {
            # join the existing script with the schema information
            Join-PipeScript -ScriptBlock $ScriptBlock, $UdpOperationScript
        }
        Interactive {
            . $UdpOperationScript
        }
    }    
}




}


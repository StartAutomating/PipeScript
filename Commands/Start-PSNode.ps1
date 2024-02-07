function Start-PSNode {

    <#
    .SYNOPSIS
        Starts a PSNode Job
    .DESCRIPTION
        Starts a PSNode Job.
        
        This will run in the current context and allow you to run PowerShell or PipeScript as a
    #>
    param(
    # The Script Block to run in the Job
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('ScriptBlock','Action')]
    [ScriptBlock]
    $Command,

    # The name of the server, or the route that is being served.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Route','Host','HostHeader')]
    [String[]]
    $Server,

    # The cross origin resource sharing
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('AccessControlAllowOrigin','Access-Control-Allow-Origin')]
    [string]
    $CORS = '*',

    # The root directory.  If this is provided, the PSNode will act as a file server for this location.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RootPath,

    # The buffer size.  If PSNode is acting as a file server, this is the size of the buffer that it will use to stream files.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Uint32]
    $BufferSize = 512kb,

    # The number of runspaces in the PSNode's runspace pool.
    # As the PoolSize increases, the PSNode will be able to handle more concurrent requests and will consume more memory.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Uint32]
    $PoolSize = 3,

    # The user session timeout.  By default, 15 minutes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [TimeSpan]$SessionTimeout,

    # The modules that will be loaded in the PSNode.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ImportModule,

    # The functions that will be loaded in the PSNode.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Functions','Function')]
    [Management.Automation.FunctionInfo[]]
    $DeclareFunction,

    # The aliases that will be loaded in the PSNode.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Alias', 'Aliases')]
    [Management.Automation.AliasInfo[]]
    $DeclareAlias,

    # Any additional types.ps1xml files to load in the PSNode.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ImportTypesFile', 'ImportTypeFiles','ImportTypesFiles')]
    [string[]]
    $ImportTypeFile,

    # Any additional format.ps1xml files to load in the PSNode.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ImportFormatsFile', 'ImportFormatFiles','ImportFormatsFiles')]
    [string[]]
    $ImportFormatFile,
    
    # If set, will allow the directories beneath RootPath to be browsed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Switch]
    $AllowBrowseDirectory,

    # If set, will execute .ps1 files located beneath the RootPath.  If this is not provided, these .PS1 files will be displayed in the browser like any other file (assuming you provided a RootPath)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Switch]
    $AllowScriptExecution,

    # The authentication type
    [Parameter(ValueFromPipelineByPropertyName=$true)]
    [Net.AuthenticationSchemes]
    $AuthenticationType = "Anonymous"
    )

    begin {
        $sourceCode = ([PSCustomObject]@{PSTypeName="PipeScript.Net"}).'PSNodeJob.cs'
        

        $ClassNamespace = if ($sourceCode -match "namespace .+?[\r\n]") {
            @("$($matches.0)" -split '\s+')[1]
        }
        
        $className = if ($sourceCode -match "class .+?[\r\n]") {
            @("$($matches.0)" -split '\s+')[1]
        }
        $targetTypeName = "$ClassNamespace.$className"
        # First, make the job type if it does not exist:
        if (-not ($targetTypeName -as [type])) {
            
        $scriptPreface = {
param($request, $response, $context, $user, $session, $application, $psNode)
$inPsNode = $true
$script:OutputOffset = 0

Add-Member ScriptMethod Write {
    param($value)

    if ($value -is [string]) {
        $buffer = [Text.Encoding]::UTF8.GetBytes($value)
        $this.OutputStream.Write($buffer, 0, $buffer.Length)
    } elseif ($value -as [byte[]]) {
        $buffer = $value -as [byte[]]
        $this.OutputStream.Write($buffer, 0, $buffer.Length)
    } elseif ($value) {
        $html = $value | Out-Html
        $buffer = [Text.Encoding]::UTF8.GetBytes($html)
        $this.OutputStream.Write($buffer, 0, $buffer.Length)
    }
} -InputObject $response
Add-Member -InputObject $Request -MemberType ScriptProperty RequestBody {
    if ($this._CachedRequestBody) { return $this._CachedRequestBody }
    if (-not $this.InputStream) { return }

    if (-not $this.psobject.properties.item('RequestBytes')) {
        $ms = [IO.MemoryStream]::new()
        $this.InputStream.CopyTo($ms)
        $this.psobject.properties.add((
            [psnoteproperty]::new('RequestBytes', $ms.ToArray())
        ))
    }
    if (-not $ms) {
        $ms = [io.memorystream]::new($this.RequestBytes)
    }
    $null = $ms.Seek(0,0)
    $requestBody =
        if ($this.ContentType -like 'text/*' -or $this.ContentType -like 'application/*') {
            $sr = [IO.StreamReader]::new($ms, $this.ContentEncoding)
            $sr.ReadToEnd()
            $sr.Close()
            $sr.Dispose()
        } elseif ($this.ContentType -like 'multipart/*;*') {
            $sr = [io.streamreader]::new($ms, [Text.Encoding]::ASCII)
            $sr.ReadToEnd()
            $sr.Close()
            $sr.Dispose()
        } else {
            $ms.ToArray()
        }
    $this.psobject.properties.add((
        [psnoteproperty]::new('_CachedRequestBody', $requestBody)
    ))
    return $requestBody
}
Add-Member -InputObject $request -MemberType ScriptProperty -Name Params -Value {
    $requestParams = @{}
    if ("$($request.QueryString)" -or $Request.HasEntityBody) {
        if ("$($request.QueryString)") {
            $query = ([uri]$request.RawUrl -split '/')[-1]
            foreach ($_ in $query.TrimStart('?') -split '&') {
                if (-not $_) { continue }
                $key, $value = $_ -split '='
                $requestParams[[Web.HttpUtility]::UrlDecode($key)] = [Web.HttpUtility]::UrlDecode($value)
            }
        }

        if ($request.HasEntityBody) {
            $rawData = $this.RequestBody
            $ms = [IO.MemoryStream]::new($this.RequestBytes)

            $boundary =
                if ($this.ContentType -like 'multipart/*;*') {
                    @(@($request.ContentType -split ';')[1] -split '=')[1]
                }
            if ($boundary) {
                $boundaries = [Regex]::Matches($rawData, $boundary)
                for ($i = 0; $i -lt ($boundaries.Count - 1); $i++) {
                    $startBoundary, $endBoundary = $boundaries[$i], $boundaries[$i + 1]
                    $realStart = $startBoundary.Index + $startBoundary.Length
                    $realEnd=  $endBoundary.Index - 2
                    $boundryContent = $rawData.Substring($realStart, $realEnd - $realStart)
                    $s = $boundryContent.IndexOf("`r`n`r`n")
                    if ($s -ne -1) {
                        $preamble = $boundryContent.Substring(0, $s)
                        $s+=4
                        $name =
                            foreach ($_ in $preamble -split ';') {
                                $_ = $_.Trim()
                                if ($_.StartsWith('name=')) {
                                    $_.Substring(5).Trim('"').Trim("'")
                                    break
                                }
                            }

                        $null= $ms.Seek($realStart + $s, 0)
                        $buffer = [byte[]]::new($realEnd - ($realStart + $s))
                        $bytesRead = $ms.Read($buffer,0, $buffer.Length)
                        if ($preamble.IndexOf('Content-Type', [StringComparison]::OrdinalIgnoreCase) -eq -1) {
                            $ms2 = [io.memorystream]::new($buffer)
                            $sr2 = [io.StreamReader]::new($ms2, $this.ContentEncoding)
                            $requestParams[$name] = $sr2.ReadToEnd().TrimEnd()
                            $sr2.Dispose()
                            $ms2.Dispose()
                        } else {
                            $requestParams[$name] = $buffer
                        }
                    }
                }
            } 
            elseif ($rawData -match '^\s[\{\[](?!@)') {
                try {
                    $parsedData = ConvertFrom-Json $rawData
                    foreach ($k in $parsedData.psobject.properties) {
                        $requestParams[$k.Name] = $parsedData[$k.Value]
                    }
                } catch {
                }
            }
            else {
                try {
                    $parsedData = [Web.HttpUtility]::ParseQueryString($rawData)
                    foreach ($k in $parsedData.Keys) {
                        $requestParams[$k] = $parsedData[$k]
                    }
                } catch {
                }                
            } 
            $ms.Close()
            $ms.Dispose()
        }
    }
    return $requestParams
}

}
        
            $sourceCode = $sourceCode.Replace("<#ScriptPreface#>", $scriptPreface.ToString().Replace('"','""'))
            $addedType = if ($PSVersionTable.Platform -eq 'Unix') {

                $linuxRefs =
                    "System.Web",([IO.Path].Assembly),([PSObject].Assembly),
                    ([Net.HttpListener].Assembly), ([IO.FileInfo].Assembly),
                    ([IO.StreamWriter].Assembly), ([Net.Cookie].Assembly),
                    ([Security.Principal.IPrincipal].Assembly),
                    'System.Collections', ([Web.HttpUtility].Assembly),
                    ([Timers.Timer].Assembly), 'System.ComponentModel.Primitives',
                    ([Collections.Specialized.NameValueCollection].Assembly),
                    ([Regex].Assembly),[Net.WebHeaderCollection].Assembly
                $linuxRefs += [PSObject].Assembly.GetReferencedAssemblies()

                $compilerParams = "-r:$([PSObject].Assembly.Location)", "-r:$([Hashtable].Assembly.Location)"
                Add-Type -TypeDefinition $sourceCode  -ReferencedAssemblies $linuxRefs  -IgnoreWarnings -CompilerOptions $compilerParams -PassThru
            } else {
                Add-Type -TypeDefinition $sourceCode -IgnoreWarnings -PassThru
            }

            if (-not $addedType) {
                Write-Error "Could not add type"
                return
            }
        }

    }

    process {
        if (-not $name) {$name = [GUID]::NewGuid() }

        $props = @{} + $PSBoundParameters
        $server = foreach ($pathToServe in $server) {
            @(switch -regex ($server) {
                "^(?!https?://)" {
                    "http://"
                }
                "." {
                    $server
                }
                "(?<!/)" {
                    '/'
                }
            }
            ) -join ''
        }
        $props["ListenerLocation"] =  $Server -replace '//$', '/'
        $props.Remove('Server')
        $props.PSNodeAction = $Command
        $props.Remove('Command')

        $myModuleName = $MyInvocation.MyCommand.ScriptBlock.Module.Name
        if ((-not $props["ImportModule"]) -or ($props["ImportModule"] -notcontains $myModuleName)) {
            $props["ImportModule"] = @(@("PipeScript") + $props["ImportModule"]) -notmatch '^\s{0,}$'
        }

        if (-not $props.BufferSize) {$props.BufferSize = $BufferSize}
        if (-not $props.CORS) { $props.CORS } 

        $nodeJobType = $targetTypeName -as [Type]
        if (-not $nodeJobType) { return }

        $NodeProperties = foreach ($_ in $nodeJobType.GetProperties("Instance,Public")) { $_ }
        $NodePropertyNames = foreach ($_ in $NodeProperties) { $_.Name }
        foreach ($_ in @($props.Keys)) {
            if ($NodePropertyNames -notcontains $_) {
                $props.Remove($_)
            }
        }

        $props.Remove('Debug')
        $props.Remove('Verbose')

        $psNodeJobInstance= New-Object $targetTypeName ($name, "$Command",$Command)  -Property $props

        if ($psNodeJobInstance) {
            $psNodeJobInstance.Start()
            $null = $PSCmdlet.JobRepository.Add($psNodeJobInstance)
            $psNodeJobInstance
        }
    }

}


[ValidatePattern("Parse")]
param()

function Out-Parser
{
    <#
    .Synopsis
        Outputs Parser to PowerShell
    .Description
        Outputs Parser as PowerShell Objects.

        Parser Output can be provided by any number of Commands to Out-Parser.

        Commands use two attributes to indicate if they should be run:

        ~~~PowerShell
        [Management.Automation.Cmdlet("Out","Parser")] # This signals that this is an Command for Out-Parser
        [ValidatePattern("RegularExpression")]      # This is run on $ParserCommand to determine if the Command should run.
        ~~~
    .LINK
        Invoke-Parser
    .NOTES
        Out-Parser will generate two events upon completion.  They will have the source identifiers of "Out-Parser" and "Out-Parser $ParserArgument"
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # One or more output lines to parse.
    [Parameter(ValueFromPipeline)]
    [Alias('ParserOutputLines')]
    [string[]]
    $ParserOutputLine,

    # The command line that describes what is being parsed.
    [string]
    $CommandLine,
    
    # The pattern used to identify lines with errors
    [string]
    $ErrorPattern = "^(?:error|fatal):",

    # The pattern used to identify lines with warnings
    [string]
    $WarningPattern = '^hint:',

    # The timestamp.   This can be used for tracking.  Defaults to [DateTime]::Now
    [DateTime]
    $TimeStamp = [DateTime]::Now
    )

    begin {        
        if ((-not $CommandLine) -and ($MyInvocation.InvocationName -ne $MyInvocation.MyCommand.Name)) {
            $CommandLine = $MyInvocation.InvocationName
        }

        $ParserCommand = $CommandLine

        # Now we need to see if we have have a cached for Command mapping.
        if (-not $script:ParserCommandMappingCache) {
            $script:ParserCommandMappingCache = @{} # If we don't, create one.
        }

        if (-not $script:ParserCommandMappingCache[$ParserCommand]) { # If we don't have a cached Command list
            $script:ParserCommandMappingCache[$ParserCommand] = $PSParser.ForCommand($ParserCommand)
        }
        # If there was already an Command cached, we can skip the previous steps and just reuse the cached Commands.
        $ParserOutputCommands = $script:ParserCommandMappingCache[$ParserCommand]
    
        # Next we want to create a collection of SteppablePipelines.
        # These allow us to run the begin/process/end blocks of each Command.
        $steppablePipelines =
            [Collections.ArrayList]::new(@(if ($ParserOutputCommands) {
                foreach ($ext in $ParserOutputCommands) {
                    $scriptCmd = {& $ext}
                    $scriptCmd.GetSteppablePipeline()
                }
            }))


        # Next we need to start any steppable pipelines.
        # Each Command can break, continue in it's begin block to indicate it should not be processed.
        $spi = 0
        $spiToRemove = @()
        $beginIsRunning = $false
        # Walk over each steppable pipeline.
        :beginParser foreach ($steppable in $steppablePipelines) {
            if ($beginIsRunning) { # If beginIsRunning is set, then the last steppable pipeline continued
                $spiToRemove+=$steppablePipelines[$spi] # so mark it to be removed.
            }
            $beginIsRunning = $true      # Note that beginIsRunning=$false,
            try {
                $steppable.Begin($true) # then try to run begin
            } catch {
                $PSCmdlet.WriteError($_) # Write any exceptions as errors
            }
            $beginIsRunning = $false     # Note that beginIsRunning=$false
            $spi++                       # and increment the index.
        }

        # If this is still true, an extenion used 'break', which signals to stop processing of it any subsequent pipelines.
        if ($beginIsRunning) {
            $spiToRemove += @(for (; $spi -lt $steppablePipelines.Count; $spi++) {
                $steppablePipelines[$spi]
            })
        }

        # Remove all of the steppable pipelines that signaled they no longer wish to run.
        foreach ($tr in $spiToRemove) {
            $steppablePipelines.Remove($tr)
        }

        $AllParserOutput    = [Collections.Queue]::new()
        $ProcessedOutput = [Collections.Queue]::new()
        $OutputLineCount = 0
    }

    process {
        # Walk over each output.

        :NextOutputLine foreach ($out in $ParserOutputLine) {
            $OutputLineCount++
            # If the out was a literal string of 'System.Management.Automation.RemoteException',
            if ("$out" -eq "System.Management.Automation.RemoteException") {
                # ignore it and continue (these things happen with some exes from time to time).
                continue
            }

            try {
                $AllParserOutput.Enqueue($out)
                
                # Wrap the output in a PSObject
                $ParserOut = [PSObject]::new($out)
            } catch {
                Write-Error "Line $outputLineCount : $_"
                continue
            }
            # Next, clear it's typenames and determine an automatic typename.            
            $ParserOut.pstypenames.clear()            
            $ParserOut.pstypenames.add('Parser.output')

            # All ParserOutput should attach the original output line, as well as the command that produced that line.
            $ParserOut.psobject.properties.add([PSNoteProperty]::new('ParserOutput',"$out"))
            $ParserOut.psobject.properties.add([PSNoteProperty]::new('ParserCommand',$CommandLine))

            # If the output started with "error" or "fatal"
            if ("$out" -match $ErrorPattern) {
                $exception = [Exception]::new($("$out" -replace $ErrorPattern)) # Create an exception
                $PSCmdlet.WriteError( # and write an error using $psCmdlet (this simplifies the displayed callstack).
                    [Management.Automation.ErrorRecord]::new($exception,"$ParserCommand", 'NotSpecified',$ParserOut)
                )
                # If there was an error, cancel all steppable pipelines (thus stopping any Commands)
                $steppablePipelines = @()
                continue # then move onto the next output.
            } else {
                Write-Verbose "$out"
            }

            if ("$out" -match $WarningPattern) {
                Write-Warning ("$out" -replace $WarningPattern)
                continue
            }

            if (-not $steppablePipelines) {
                # If we do not have steppable pipelines, output directly
                $ParserOut
            }
            else {
                # If we have steppable pipelines, then we have to do a similar operation as we did for begin.
                $spi = 0
                $spiToRemove = @()
                $processIsRunning = $false
                # We have to walk thru each steppable pipeline,
                :processParser foreach ($steppable in $steppablePipelines) {
                    if ($processIsRunning) {  # if $ProcessIsRunning, the pipeline was skipped with continue.
                        $spiToRemove+=$steppablePipelines[$spi] # and we should add it to the list of pipelines to remove
                    }
                    $processIsRunning = $true # Set $processIsRunning,
                    try {
                        $steppable.Process($ParserOut) | & {
                            process {
                                $ProcessedOutput.Enqueue($_)
                                $_
                            }
                        } # attempt to run process, using the $ParserOut object.
                    } catch {
                        $PSCmdlet.WriteError($_)    # (catch any exceptions and write them as errors).
                    }
                    $processIsRunning = $false # Set $processIsRunning to $false for the next step.
                }


                if ($processIsRunning) {  # If $ProcessIsRunning was true, the Command used break
                    # which should signal cancellation of all subsequent Commands.
                    $spiToRemove += @(for (; $spi -lt $steppablePipelines.Count; $spi++) {
                        $steppablePipelines[$spi]
                    })


                    $ParserOut # We will also output the ParserOut object in this case.
                }

                # Remove any steppable pipelines we need to remove.
                foreach ($tr in $spiToRemove) { $steppablePipelines.Remove($tr) }
            }
        }
    }

    end {
        $global:lastParserOutput = $AllParserOutput.ToArray()

        # End remaining steppable pipelines need to end.
        # Ending does not support the cancellation of other Commands.
        :endParser foreach ($steppable in $steppablePipelines) {
            try {
                $steppable.End() | & { process {
                    $ProcessedOutput.Enqueue($_)
                    $_
                }}
            } catch {
                Write-Error -ErrorRecord $_
            }
        }

        if (-not $global:ParserHistory -or
            $global:ParserHistory -isnot [Collections.IDictionary]) {
            $global:ParserHistory = [Ordered]@{}
        }
        $messageData = [Ordered]@{
            OutputObject  = $ProcessedOutput.ToArray()
            ParserOutputLine = $AllParserOutput.ToArray()
            CommandLine      =  @(@("Parser") + $ParserArgument) -join ' '            
            TimeStamp     = $TimeStamp
        }

        $eventSourceIds = @("Out-Parser","Out-Parser $CommandLine")

        $null =
            foreach ($sourceIdentifier in $eventSourceIds) {
                New-Event -SourceIdentifier $sourceIdentifier -MessageData $messageData
            }

        $global:ParserHistory["$($MyInvocation.HistoryId)::$ParserRoot::$ParserArgument"] = $messageData
    }
}

function Get-PipeScript
{
    <#
    .SYNOPSIS
        Gets PipeScript.
    .DESCRIPTION        
        Gets PipeScript and it's extended commands.

        Because 'Get' is the default verb in PowerShell,
        Get-PipeScript also allows you to run other commands in noun-oriented syntax.
    .EXAMPLE
        # Get every specialized PipeScript command
        Get-PipeScript
    .EXAMPLE
        # Get all transpilers
        Get-PipeScript -PipeScriptType Transpiler
    .EXAMPLE
        # Get all template files within the current directory.
        Get-PipeScript -PipeScriptType Template -PipeScriptPath $pwd
    .EXAMPLE
        # You can use `noun verb` to call any core PipeScript command.
        PipeScript Invoke { "hello world" } # Should -Be 'Hello World'
    .EXAMPLE
        # You can still use the object pipeline with `noun verb`
        { partial function f { } }  |
            PipeScript Import -PassThru # Should -BeOfType ([Management.Automation.PSModuleInfo])
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The path containing pipescript files.
    # If this parameter is provided, only PipeScripts in this path will be outputted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname','FilePath','Source')]
    [string]
    $PipeScriptPath,

    # One or more PipeScript Command Types.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidValues(Values={
        @((Aspect.ModuleExtensionType -Module PipeScript).psobject.properties).Name | Sort-Object        
    })]
    [string[]]
    $PipeScriptType,

    # Any positional arguments that are not directly bound.
    # This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Args')]
    $Argument,

    # The InputObject.
    # This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.
    [Parameter(ValueFromPipeline)]
    [Alias('Input','In')]    
    $InputObject,

    # If set, will force a refresh of the loaded Pipescripts.
    [switch]
    $Force
    )

    dynamicParam {

             

        $myModule = Get-Module PipeScript
        $myInv    = $MyInvocation
        
        # Fun PowerShell fact:  'Get' is the default verb.
        # So when someone uses a noun-centric form of PipeScript, this command will be called.
        if ($MyInvocation.InvocationName -eq 'PipeScript') {
            # In this way, we can 'trick' the command a bit.
            $myCmdAst  = $myCommandAst
            
            if (-not ($myCmdAst -or $MyInvocation.Line -match '(?<w1>PipeScript)\s(?<w2>\S+)')) { return }
                
            $FirstWord, $secondWord, $restOfLine = 
                if ($myCmdAst.CommandElements) {
                    $myCmdAst.CommandElements
                } elseif ($matches) {
                    $matches.w1, $matches.w2
                }

            # If the second word is a verb and the first is a noun
            if ($myModule.ExportedCommands["$SecondWord-$FirstWord"] -and # and we export the command
                $myModule.ExportedCommands["$SecondWord-$FirstWord"] -ne $myInv.MyCommand # (and it's not this command)
            ) {
                # Then we could do something, like:             
                $myModule.ExportedCommands["$SecondWord-$FirstWord"] |
                    Aspect.DynamicParameter -PositionOffset 1 -ExcludeParameter @($myInv.MyCommand.Parameters.Keys) -BlankParameterName Verb                                
            }                                    
        }
    }

    begin {
        #region Declare Internal Functions and Filters
        function SyncPipeScripts {
            param($Path,$Force)

            # If we do not have a commands at path collection, create it.
            if (-not $script:CachedCommandsAtPath) {
                $script:CachedCommandsAtPath = @{}
            }

            
            if ($Force) { # If we are using -Force,                                
                if ($path) { # Then check if a -Path was provided,
                    # and clear that path's cache.
                    $script:CachedCommandsAtPath[$path] = @()
                } else {
                    # If no -Path was provided,                    
                    $script:CachedPipeScripts = $null # clear the command cache.
                }                
            }
            
            # If we have not cached all pipescripts.
            if (-not $script:CachedPipeScripts -and -not $Path) {                
                $script:CachedPipeScripts = @(
                    # Find the extended commands for PipeScript
                    Aspect.ModuleExtendedCommand -Module $myModule -PSTypeName PipeScript

                    # Determine the related modules for PipeScript.
                    $moduleRelationships = [ModuleRelationships()]$myModule
                    $relatedPaths = @(foreach ($relationship in $moduleRelationships) {
                        $relationship.RelatedModule.Path | Split-Path
                    })
                    
                    # then find all commands within those paths.
                    Aspect.ModuleExtendedCommand -Module PipeScript -FilePath $relatedPaths -PSTypeName PipeScript
                )
            }

            if ($path -and -not $script:CachedCommandsAtPath[$path]) {
                $script:CachedCommandsAtPath[$path] = @(
                    Aspect.ModuleExtendedCommand -Module PipeScript -FilePath $path -PSTypeName PipeScript
                )
            }
        }

        filter CheckPipeScriptType
        {
            if ($PipeScriptType) {
                $OneOfTheseTypes = "(?>$($PipeScriptType -join '|'))"
                $in = $_
                if (-not ($in.pstypenames -match $OneOfTheseTypes)) {
                    return
                }
            }
            $_
        }

        filter unroll { $_ }   
        #endregion Declare Internal Functions and Filters
        
        $steppablePipeline = $null
        if ($MyInvocation.InvocationName -eq 'PipeScript') {
            $mySplat = [Ordered]@{} + $PSBoundParameters
            $myCmdAst  = $myCommandAst
            if ($myCmdAst -or $MyInvocation.Line -match '(?<w1>PipeScript)\s(?<w2>\S+)') {
                
                $FirstWord, $secondWord, $restOfLine = 
                    if ($myCmdAst.CommandElements) {
                        $myCmdAst.CommandElements
                    } elseif ($matches) {
                        $matches.w1, $matches.w2
                    }
                
                # If the second word is a verb and the first is a noun
                if ($myModule.ExportedCommands["$SecondWord-$FirstWord"] -and # and we export the command
                    $myModule.ExportedCommands["$SecondWord-$FirstWord"] -ne $myInv.MyCommand # (and it's not this command)
                ) {
                    # Remove the -Verb parameter,
                    $mySplat.Remove('Verb')
                    # get the export,
                    $myExport = $myModule.ExportedCommands["$SecondWord-$FirstWord"]
                    # turn positional arguments into an array,
                    $myArgs = @(
                        if ($mySplat.Argument) {
                            $mySplat.Argument
                            $mySplat.Remove('Argument')
                        }
                    )
                    
                    # create a steppable pipeline command,
                    $steppablePipelineCmd = {& $myExport @mySplat @myArgs}
                    # get a steppable pipeline,
                    $steppablePipeline = $steppablePipelineCmd.GetSteppablePipeline($MyInvocation.CommandOrigin)
                    # and start the steppable pipeline.
                    $steppablePipeline.Begin($PSCmdlet)
                }                
            }            
        }
        
        # If there was no steppable pipeline
        if (-not $steppablePipeline -and 
            $Argument -and # and we had arguments
            $(
                $argPattern = "(?>$($argument -join '|'))" -as [Regex]
                $validArgs = $myInv.MyCommand.Parameters['PipeScriptType'].Attributes.ValidValues -match $argPattern # that could be types                
                $validArgs
            )
        ) {
            # imply the -PipeScriptType parameter positionally.
            $PipeScriptType = $validArgs
        }
    }
    process {
        $myInv = $MyInvocation
        if ($steppablePipeline) {
            $steppablePipeline.Process($_)
            return
        }

        # If the invocation name is PipeScript (but we have no steppable pipeline or spaced in the name)
        if ($myInv.InvocationName -eq 'PipeScript' -and $myInv.Line -notmatch 'PipeScript\s[\S]+') {
            # return the module
            return $myModule
        }
        
        if ($inputObject -and $InputObject -is [Management.Automation.CommandInfo]) {
            Aspect.ModuleExtensionCommand -Module PipeScript -Commands $inputObject
        }
        elseif ($InputObject -and $InputObject -is [IO.FileInfo]) {
            $inputObjectCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($InputObject.FullName, 'ExternalScript,Application')
            Aspect.ModuleExtensionCommand -Module PipeScript -Commands $inputObjectCommand
        }
        elseif ($PipeScriptPath) {
            SyncPipeScripts -Force:$Force -Path $PipeScriptPath
            $script:CachedCommandsAtPath[$PipeScriptPath] | unroll | CheckPipeScriptType
        } else {            
            SyncPipeScripts -Force:$Force

            $script:CachedPipeScripts | unroll | CheckPipeScriptType
        }
    }

    end {
        if ($steppablePipeline) {
            $steppablePipeline.End()
        }
    }
}

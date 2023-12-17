function Import-PipeScript
{
    <#
    .SYNOPSIS
        Imports PipeScript
    .DESCRIPTION
        Imports PipeScript in a dynamic module.
    .EXAMPLE
        Import-PipeScript -ScriptBlock {
            function gh {
                [Inherit('gh',CommandType='Application')]
                param()
            }
        }
    .EXAMPLE
        Import-PipeScript -ScriptBlock {
            partial function f {
                "This will be added to any function named f."
            }
        }
    #>
    [Alias('imps','.<')]
    param(    
    # The Command to run or ScriptBlock to import.
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('ScriptBlock','CommandName', 'CommandInfo')]
    [ValidateScript({
        $PotentialCommand = $_
        if ($null -eq $PotentialCommand)         { return $false }
        if ($PotentialCommand -is [ScriptBlock]) { return $true }
        if ($PotentialCommand -is [string])      { return $true }
        if ($PotentialCommand -is [Management.Automation.CommandInfo]) { return $true }
        return $false
    })]    
    $Command,
    
    # Indicates that this returns a custom object with members that represent the imported module members
    # When you use the AsCustomObject parameter, Import-PipeScript imports the module members into the session and then returns a    
    # PSCustomObject object instead of a PSModuleInfo object. You can save the custom object in a variable and use dot notation    
    # to invoke the members.
    [switch]
    $AsCustomObject,

    # Returns an object representing the item with which you're working. By default, this cmdlet does not generate any output.
    [switch]
    $PassThru,

    # Specifies a name for the imported module.
    # The default value is an autogenerate name containing the time it was generated.
    [string]
    $Name,

    # If set, will not transpile a -Command that is a [ScriptBlock]
    # All other types of -Command will be transpiled, disregarding this parameter.
    [switch]
    $NoTranspile
    )

    process {
        $NewModuleSplat = [Ordered]@{}
        if ($Command -is [scriptblock]) {
            $NewModuleSplat.ScriptBlock =
                if ($NoTranspile) {
                    $Command
                } else {
                    $Command | .>Pipescript
                }
        } else {
            $NewModuleSplat.ScriptBlock = {
                $Command = $args[0]
                $Output  = 
                    foreach ($invokePipeScriptOutput in Invoke-PipeScript -Command $Command )  {
                        if ($invokePipeScriptOutput -is [IO.FileInfo] -and 
                            $invokePipeScriptOutput.Extension -eq '.ps1') {
                            . $invokePipeScriptOutput.Fullname
                        } elseif ($invokePipeScriptOutput -is [ScriptBlock]) {
                            . $invokePipeScriptOutput
                        } else {
                            $invokePipeScriptOutput
                        }
                    }
            }
            $NewModuleSplat.ArgumentList = @($Command)
        }
        
        $exportAll      =
            {Export-ModuleMember -Function * -Alias * -Variable * -Cmdlet *}        

        $NewModuleSplat.Name = if ($name) {
            $name
        } else {
            "PipeScript@$([datetime]::Now.ToString('s'))"
        }

        $NewModuleSplat.ScriptBlock = [ScriptBlock]::create((
            $NewModuleSplat.ScriptBlock,                    
            $exportAll -join [Environment]::NewLine
        ))
        
        $importedModule =         
            New-Module @NewModuleSplat|
                Import-Module -Global -Force -PassThru -AsCustomObject:$AsCustomObject |
                Add-Member ImportedAt ([datetime]::Now) -Force -PassThru

        # Create an event indicating that PipeScript has been imported.
        $null = New-Event -SourceIdentifier PipeScript.Imported -MessageData ([PSCustomObject][Ordered]@{
            PSTypeName = 'PipeScript.Imported'
            ModuleName = $NewModuleSplat.Name
            ScriptBlock = $NewModuleSplat.ScriptBlock
        })

        if ($passThru) {
            $importedModule
        }
    }
}

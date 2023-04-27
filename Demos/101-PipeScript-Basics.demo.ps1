# 1. PipeScript 101

# PipeScript is a transpiled programming language built atop of PowerShell.

# It aims to make scripting more programmable, and programming more scriptable.

# Using PipeScript, we can expand the syntax of PowerShell in all sorts of ways.

# Let's start with a little example.

# Many modules include a bunch of files in a given directory.

# Instead of typing the same few lines over and over again, we can use the 'include' transpiler 

Use-PipeScript { 
    [Include('*-*.ps1')]$PSScriptRoot
}

# This means we could write the .psm1 for almost any module in a single line.

# Let's prove the point by writing a quick module

{[include('*-*.ps1')]$psScriptRoot} | Set-Content .\PipeScriptDemo.ps.psm1

# Now, we can export or "build" the file using Export-PipeScript

Export-PipeScript .\PipeScriptDemo.ps.psm1

# We don't have any functions written yet, so let's make one of those, too.

# We can also use psuedo-attributes to make parameters with less code.
# In this case, we use `vfp` to shorten ValueFromPipeline, and `vbn` to shorten ValueFromPipelineByPropertyName
{
    function Send-Event {
        param(
        [vbn(Mandatory)]
        [Alias('EventName')]
        $SourceIdentifier,
        [vfp()]
        $MessageData,
        [vbn()]
        [switch]
        $Passthru
        )

        process {
            $sentEvent = New-Event -SourceIdentifier $SourceIdentifier -MessageData $MessageData
            if ($Passthru) {
                $sentEvent
            }
        }
    }
} | Set-Content .\Send-Event.ps.ps1

# Why stop at one command?

# Let's use another very powerful transpiler, Inherit.

{
    function Receive-Event
    {
        [Inherit('Get-Event',Abstract)]
        param()

        process {
            $null = $PSBoundParameters.Remove('First')
            $events = @(& $BaseCommand @PSBoundParameters)
            [Array]::Reverse($events)
            $events            

        }
    }
} | Set-Content .\Receive-Event.ps.ps1

# Let's export again, this time using it's alias, bps (Build-PipeScript)

bps


# All set?  Let's import our module:
Import-Module .\PipeScriptDemo.psm1 -Force -PassThru
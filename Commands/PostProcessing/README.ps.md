## PostProcessing Commands

PostProcessing commands can run after PipeScript has built a script or function.

A PostProcessing command will be passed the script or function and will return a new script or function if anything was modified.

~~~PipeScript{    
    [PSCustomObject]@{
        Table = Get-PipeScript -PipeScriptType PostProcessing |
            Select-Object Name, Synopsis, @{
                Name='Link'
                Expression = { "/docs/$($_.Name).md" }
            }
    }
}
~~~
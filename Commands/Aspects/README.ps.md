## Aspects in PipeScript

An Aspect is a small, resuable function.

Aspects are meant to be embedded within other code, though they can also be used interactively.

When a file is built, any aspects will be consolidated and embedded inline.

~~~PipeScript{    
    [PSCustomObject]@{
        Table = Get-PipeScript -PipeScriptType Aspect |
            Select-Object Name, Synopsis, @{
                Name='Link'
                Expression = { "/docs/$($_.Name).md" }
            }
    }
}
~~~


## Aspect Examples

All of the current aspect examples are listed below:

~~~PipeScript{
    @(foreach ($protocolCommand in Get-PipeScript -PipeScriptType Aspect) {
        $examples = @($protocolCommand.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("## $($protocolCommand.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~



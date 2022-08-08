# PipeScript Keywords

PipeScript contains several new language keywords that are not found in PowerShell.

This directory contains the implementations of PipeScript language keywords.

## Keyword List

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object DisplayName, Synopsis, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }}
~~~

# Examples

~~~PipeScript{
    @(foreach ($transpiler in Get-Transpiler -TranspilerPath $pwd) {
        $examples = @($transpiler.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("## $($transpiler.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~



Keywords will generally be implemented as a Transpiler that tranforms a CommandAST.

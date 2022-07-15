This directory and it's subdirectories contain additional language keywords within PipeScript.

Most keywords will be implemented as a Transpiler that tranforms a CommandAST.

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object DisplayName, Synopsis, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }}
~~~


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

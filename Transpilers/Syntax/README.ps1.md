This directory and it's subdirectories contain syntax changes that enable common programming scenarios in PowerShell and PipeScript.

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

This directory and it's subdirectories contain syntax changes that enable common programming scenarios in PowerShell and PipeScript.

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object DisplayName, @{
                Name='Synopsis'
                Expression= { $_.Synopsis -replace '[\s\r\n]+$' }
            }, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }}
~~~

~~~PipeScript{
    $transpilers = Get-Transpiler -TranspilerPath $pwd

    @(foreach ($transpiler in $transpilers) {
        $examples = @($transpiler.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            "## $($transpiler.DisplayName) Example $($exampleNumber)" + 
                [Environment]::Newline + 
                [Environment]::Newline + 
                "~~~PowerShell" +
                [Environment]::Newline + 
                $examples[$exampleNumber - 1] +
                [Environment]::Newline + 
                "~~~" +
                [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~




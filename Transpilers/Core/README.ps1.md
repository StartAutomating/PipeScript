This directory and it's subdirectories contain the Core PipeScript transpilers.

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Where-Object DisplayName -ne 'PipeScript' |
            Select-Object DisplayName, @{
                Name='Synopsis'
                Expression= { $_.Synopsis -replace '[\s\r\n]+$' }
            }, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }
}
~~~

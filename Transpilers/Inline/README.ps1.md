This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in ```.>{@(Get-Transpiler -TranspilerPath $pwd).Count}<.``` languages or file types.

### Supported Languages

~~~PipeScript{
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Select-Object @{
                Name='Language'
                Expression= {$_.DisplayName -replace '^Inline\.'}
            }, @{
                Name='Synopsis'
                Expression= { $_.Synopsis -replace '[\s\r\n]+$' }
            }, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }
}
~~~
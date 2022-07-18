This directory contains Inline PipeScript transpilers for several languages.

PipeScript can currently be embedded in ```.>{@(Get-Transpiler -TranspilerPath $pwd).Count}<.``` languages or file types.

Transpilers in this directory should be named ```Inline.NameOfLanguage.psx.ps1```.
Each file should handle one and only one language (better explicit than terse).

Transpilers should call ```.>PipeScript.Inline``` to simplify and standarize processing.

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

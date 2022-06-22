Files in this directory and it's subdirectories generate wrappers for PipeScript and PowerShell.

These wrappers allow PipeScript or PowerShell to be called from other programming languages.

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
    }
}
~~~
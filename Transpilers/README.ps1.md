This directory and it's subdirectories contain the Transpilers that ship with PipeScript.

Transpilers should have the extension ```.psx.ps1```

Any other module can define it's own Transpilers.

All the module needs to do for the transpilers to be recognized by PipeScript is add PipeScript to the ```.PrivateData.PSData.Tags``` section of the module's manifest file.

This directory includes uncategorized or 'common' transpilers.

~~~PipeScript{
    
    [PSCustomObject]@{
        Table = Get-Transpiler -TranspilerPath $pwd |
            Where-Object Path -Match ([regex]::escape($pwd) + "[\\/][^\\/]+$") |
            Select-Object DisplayName, Synopsis, @{
                Name='Link'
                Expression = { $_.Name }
            }
    }}
~~~

### Examples

~~~PipeScript{
    @(foreach ($transpiler in Get-Transpiler -TranspilerPath $pwd  |
            Where-Object Path -Match ([regex]::escape($pwd) + "[\\/][^\\/]+$")) {
        $examples = @($transpiler.Examples)
        if (-not $examples) { continue }
        for ($exampleNumber = 1; $exampleNumber -le $examples.Length; $exampleNumber++) {
            @("#### $($transpiler.DisplayName) Example $($exampleNumber)", 
                [Environment]::Newline,
                "~~~PowerShell",                
                $examples[$exampleNumber - 1],                
                "~~~") -join [Environment]::Newline
        }        
    }) -join ([Environment]::Newline * 2)
}
~~~




Template function Include.c {
    <#
    .SYNOPSIS
        C Include Template
    .DESCRIPTION
        Template for Include statements in C
    #>
    [Alias('Import.c','Require.c','Imports.c','Requires.c','Includes.c')]
    param(
    # The name of one or more libraries to import
    [vbn()]
    [Alias('ModuleName','PackageName')]
    [string[]]
    $LibraryName,
    
    # If the library is a system header, it will be included with `<>`.
    # This is also known as a `-StandardLibrary`, and is also aliased to `-Global`.
    [Alias('Global','StandardLibrary')]
    [switch]
    $IsSystemHeader
    )

    process {
        foreach ($libName in $LibraryName) {
"#include $(if ($IsSystemHeader) { '<'} else {'"'})$libName$(if ($IsSystemHeader) { '>'} else {'"'})"
        }
    }
}

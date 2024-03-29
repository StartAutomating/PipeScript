Template function Import.py {
    <#
    .SYNOPSIS
        Python Import Template
    .DESCRIPTION
        Template for Import statements in Python
    .EXAMPLE
        Template.Import.py -ModuleName sys
    .EXAMPLE
        'sys','json' | Template.Import.py -As { $_[0] }
    #>
    [Alias('Import.py','Require.py','Imports.py','Requires.py','Includes.py')]
    param(
    # The name of one or more libraries to import.    
    [vbn(ValueFromPipeline)]
    [Alias('LibraryName','PackageName')]
    [string[]]
    $ModuleName,

    # The name of one or more functions to import from the module
    [vbn()]
    [Alias('From')]
    [string]
    $Function,
    
    # The alias for the imported type or function.
    [vbn()]
    [Alias('Alias')]
    [string]
    $As
    )

    process {
@"
$(if ($Function) {
    "from$($ModuleName -join ',') import $($functionName -join ",")$(if ($As) {" as $As"})"
} elseif ($As) {
    "import $($ModuleName -join ',') as $As"
} else {
    "import $($ModuleName -join ',')"
})
"@
    }
}

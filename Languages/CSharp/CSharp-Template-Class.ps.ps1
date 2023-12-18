Template function Class.cs {
    <#
    .SYNOPSIS
        Template for CSharp Class
    .DESCRIPTION
        A Template for a CSharp Class Definition
    #>
    param(
    # The class name.
    [vbn()]
    [Alias('Identifier')]
    [string]
    $Class,
    
    # The class modifiers.  Creates public classes by default.
    [vbn()]
    [Alias('Modifiers')]
    [string[]]
    $Modifier = 'public',

    # One or more class attributes
    [vbn()]
    [Alias('Attributes','ClassAttribute','ClassAttributes')]
    [string[]]
    $Attribute,

    # The body of the class.
    [vbn()]
    [Alias('Members','Member')]
    [string[]]
    $Body
    )
        
    process {
@"
$(if ($Attribute) {($Attribute -join [Environment]::NewLine) + [Environment]::NewLine})$($Modifier -join ' ') class $Class {
$($body -join [Environment]::NewLine)
}
"@
    }    
}

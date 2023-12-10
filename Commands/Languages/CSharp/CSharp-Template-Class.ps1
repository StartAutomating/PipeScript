
function Template.Class.cs {

    <#
    .SYNOPSIS
        Template for CSharp Class
    .DESCRIPTION
        A Template for a CSharp Class Definition
    #>
    param(
    # The class name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Identifier')]
    [string]
    $Class,
    
    # The class modifiers.  Creates public classes by default.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Modifiers')]
    [string[]]
    $Modifier = 'public',

    # One or more class attributes
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attributes','ClassAttribute','ClassAttributes')]
    [string[]]
    $Attribute,

    # The body of the class.
    [Parameter(ValueFromPipelineByPropertyName)]
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



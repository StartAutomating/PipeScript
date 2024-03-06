[ValidatePattern("CSharp")]
param()

Template function Method.cs {
    <#
    .SYNOPSIS
        Template for CSharp Method
    .DESCRIPTION
        A Template for a CSharp Method Definition
    #>
    param(
    # The method name.
    [vbn()]
    [Alias('Identifier','Name','MethodName')]
    [string]
    $Method,
    
    # The method modifiers.  Creates public methods by default.
    [vbn()]
    [Alias('Modifiers')]
    [string[]]
    $Modifier = 'public',    

    # The return type.  By default, void.
    [vbn()]    
    [string]
    $ReturnType = 'void',

    # One or more method attributes
    [vbn()]
    [Alias('Attributes','MethodAttribute','MethodAttributes')]
    [string[]]
    $Attribute,

    # The body of the method.
    [vbn()]
    [Alias('Members','Member')]
    [string[]]
    $Body
    )
        
    process {
@"
$(if ($Attribute) {($Attribute -join [Environment]::NewLine) + [Environment]::NewLine})$($Modifier -join ' ') $(if ($ReturnType) { "$returnType "}) $method {
$($body -join [Environment]::NewLine)
}
"@
    }    
}

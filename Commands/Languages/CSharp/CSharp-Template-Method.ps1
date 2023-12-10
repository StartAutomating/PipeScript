
function Template.Method.cs {

    <#
    .SYNOPSIS
        Template for CSharp Method
    .DESCRIPTION
        A Template for a CSharp Method Definition
    #>
    param(
    # The method name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Identifier','Name','MethodName')]
    [string]
    $Method,
    
    # The method modifiers.  Creates public methods by default.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Modifiers')]
    [string[]]
    $Modifier = 'public',    

    # The return type.  By default, void.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string]
    $ReturnType = 'void',

    # One or more method attributes
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attributes','MethodAttribute','MethodAttributes')]
    [string[]]
    $Attribute,

    # The body of the method.
    [Parameter(ValueFromPipelineByPropertyName)]
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



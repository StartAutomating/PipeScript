Parse function CSharp {
    <#
    .SYNOPSIS
        Parses CSharp
    .DESCRIPTION
        Parses CSharp using Microsoft.CodeAnalysis
    .EXAMPLE
        Parse-CSharp -Source '"hello world";'
    #>
    [OutputType('Microsoft.CodeAnalysis.SyntaxTree')]
    param(
    # The source.  Can be a string or a file.
    [Parameter(ValueFromPipeline)]
    [ValidateTypes(TypeName={[string], [IO.FileInfo]})]
    [PSObject]    
    $Source
    )

    begin {
        if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
            Add-Type -AssemblyName Microsoft.CodeAnalysis.CSharp
        }    
    }

    process {
        if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
            return
        }

        if ($Source -is [string]) {
            [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText($Source)
        }
        elseif ($Source -is [IO.FileInfo]) {
            if ($Source.Extension -in '.cs', '.csx') {
                [Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree]::ParseText([IO.File]::ReadAllText($Source), $null, $Source.Fullname)                
            }
            
        }
    }
}

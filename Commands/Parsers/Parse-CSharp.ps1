
function Parse.CSharp {
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
    [ValidateScript({
    $validTypeList = [System.String],[System.IO.FileInfo]
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','System.IO.FileInfo'."
    }
    return $true
    })]
    
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



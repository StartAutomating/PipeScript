[ValidatePattern("(?>CSharp|Parse)")]
param()

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
    [Alias('Parse-CSharp')]
    param(
    # The source.  Can be a string or a file.
    [Parameter(ValueFromPipeline)]
    [Alias('Text','SourceText','SourceFile','InputObject')]
    [ValidateTypes(TypeName={[string], [IO.FileInfo]})]
    [PSObject]    
    $Source
    )

    begin {        
        if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
            Add-Type -AssemblyName Microsoft.CodeAnalysis.CSharp
        }
        $accumulate = [Collections.Queue]::new()
    }

    process {
        $accumulate.Enqueue([Ordered]@{psParameterSet=$psCmdlet.ParameterSetName} + $PSBoundParameters)
    }

    end {

        $count = 0
        $total = $accumulate.Count -as [double]
        if (-not $script:LastProgressID) { $script:LastProgressID = 1}
        $script:LastProgressID++
        if (-not ('Microsoft.CodeAnalysis.CSharp.CSharpSyntaxTree' -as [type])) {
            return
        }

        while ($accumulate.Count) {
            $dequeue = $accumulate.Dequeue()
            if ($total -gt 1) {
                Write-Progress "Parsing CSharp" " " -Id $script:LastProgressID -PercentComplete $(
                    $count++
                    [Math]::Min($count / $total, 1) * 100
                )
            }

            foreach ($kv in $dequeue.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
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
}

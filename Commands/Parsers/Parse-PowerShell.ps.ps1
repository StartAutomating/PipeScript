[ValidatePattern("(?>PowerShell|Parse)")]
param()

Parse function PowerShell {
    <#
    .SYNOPSIS
        Parses PowerShell
    .DESCRIPTION
        Parses PowerShell, using the abstract syntax tree
    .EXAMPLE
        Get-ChildItem *.ps1 | 
            Parse-PowerShell
    .EXAMPLE
        Parse-PowerShell "'hello world'"
    #>
    [OutputType([Management.Automation.Language.Ast])]
    [Alias('Parse-PowerShell')]
    param(
    # The source.  Can be a string or a file. 
    [Parameter(ValueFromPipeline)]
    [Alias('Text','SourceText','SourceFile','InputObject')]
    [ValidateTypes(TypeName={[string], [IO.FileInfo]})]
    [PSObject]    
    $Source
    )
    

    begin {
        $accumulate = [Collections.Queue]::new()
    }

    process {
        $accumulate.Enqueue([Ordered]@{} + $PSBoundParameters)
    }

    end {

        $count = 0
        $total = $accumulate.Count -as [double]
        if (-not $script:LastProgressID) { $script:LastProgressID = 1}
        $script:LastProgressID++
        while ($accumulate.Count) {
            $dequeue = $accumulate.Dequeue()
            if ($total -gt 1) {
                Write-Progress "Parsing PowerShell" " " -Id $script:LastProgressID -PercentComplete $(
                    $count++
                    [Math]::Min($count / $total, 1) * 100
                )
            }

            foreach ($kv in $dequeue.GetEnumerator()) {
                $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
            }
            if ($Source -is [string]) {
                [ScriptBlock]::Create($Source).Ast
            }
            elseif ($Source -is [IO.FileInfo]) {
                if ($Source.Extension -eq '.ps1') {
                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($Source,'ExternalScript').ScriptBlock.Ast
                }            
            }
        }
        if ($total -gt 1) {
            Write-Progress "Parsing PowerShell" " " -Completed -Id $script:LastProgressID
        }
        
    }
}

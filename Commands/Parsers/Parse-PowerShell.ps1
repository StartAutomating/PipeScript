
function Parse.PowerShell {

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



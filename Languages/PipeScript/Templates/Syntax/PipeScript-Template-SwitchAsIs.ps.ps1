[ValidatePattern("PipeScript")]
param()

Template function PipeScript.SwitchAsIs {
    <#
    .SYNOPSIS
        Switches based off of type, using as or is
    .DESCRIPTION
        Slightly rewrites a switch statement that is written with full typenames.

        Normally, PowerShell would try to match the typename as a literal string, which is highly unlikely to work.

        SwitchAsIs will take a switch statement in the form of:

        ~~~PowerShell
        switch ($t) {
            [typeName] {
                
            }
        }
        ~~~

        And rewrite it to use the casting operators

        If the label matches As or Is, it will use the corresponding operators.
    .EXAMPLE
        1..10 | Invoke-PipeScript {
            switch ($_) {
                [int] { $_ } 
                [double] { $_ }
            }
        }
    #>
    [ValidateScript({
        $validating = $_
        if ($validating -isnot [Management.Automation.Language.SwitchStatementAst]) {  return $false }
        $hasTypeKeys = $validating.Clauses.Item1 -match '^\s{0,}\[' -and $validating.Clauses.Item1 -match '\]\s{0,}$'

        if ($hasTypeKeys -and $validating.Flags -notmatch 'Regex') {
            return $true
        }
        if ($validating.Label -match '^[ai]s') {
            return $true
        }
        return $false

    })]
    param(
    # The switch statement
    [Parameter(ValueFromPipeline)]
    [Management.Automation.Language.SwitchStatementAst]
    $SwitchStatementAst
    )

    process {
        [scriptblock]::Create(
            @("switch ($($SwitchStatementAst.Condition)) {"
            foreach ($clause in $SwitchStatementAst.Clauses) {
                if ($clause.Item1 -match '^\s{0,}\[' -and $clause.Item1 -match '\]\s{0,}$') {
                    if ($SwitchStatementAst.Label -match 'as') {
                        "{`$_ -as $($clause.Item1)}"
                    } else {
                        "{`$_ -is $($clause.Item1)}"
                    }            
                    $clause.Item2.ToString()
                } else {
                    $clause.Item1
                    $clause.Item2.ToString()
                }
            }
            if ($switchStatementAst.Default) {
                "default { $($switchStatementAst.Default.ToString()) }"
            }
            "}") -join [Environment]::newLine
        )
    }
}
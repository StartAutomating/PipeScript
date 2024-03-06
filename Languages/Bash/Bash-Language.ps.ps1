[ValidatePattern("(?>Bash|Language)")]
param()

Language function Bash {
    <#
    .SYNOPSIS
        Bash Language Definition
    .DESCRIPTION
        Defines Bash within PipeScript.

        This allows Rust to be templated.

        Heredocs named PipeScript{} will be treated as blocks of PipeScript.

        ```bash
        <<PipeScript{}
        
        # This will be considered PipeScript / PowerShell, and will return the contents of a bash script.

        PipeScript{}
        ```
    .EXAMPLE
        Invoke-PipeScript {
            $bashScript = '
            echo ''hello world''

            <<PipeScript{}
                "echo ''$(''hi'',''yo'',''sup'' | Get-Random)''"
            PipeScript{}
        '
        
            [OutputFile('.\HelloWorld.ps1.sh')]$bashScript
        }

        Invoke-PipeScript .\HelloWorld.ps1.sh
    #>
    [ValidatePattern('\.sh$')]
    param(
    )
    $FilePattern  = '\.sh$'
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>\<\<PipeScript\{\})' 
    $endComment   = '(?>PipeScript\{\})'    
    
    $StartPattern = "(?<PSStart>${startComment})"
    
    $EndPattern   = "(?<PSEnd>${endComment})"

    $Interpreter = $ExecutionContext.SessionState.InvokeCommand.GetCommand('bash','Application')
}


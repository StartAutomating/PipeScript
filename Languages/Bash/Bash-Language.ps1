[ValidatePattern("(?>Bash|Language)")]
param()


function Language.Bash {
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
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
    )
    $FilePattern  = '\.sh$'
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>\<\<PipeScript\{\})' 
    $endComment   = '(?>PipeScript\{\})'    
    
    $StartPattern = "(?<PSStart>${startComment})"
    
    $EndPattern   = "(?<PSEnd>${endComment})"

    # One or more wrappers can be used to create a wrapper of a PowerShell script.
    $Wrapper       = 'Template.Bash.Wrapper'

    $Interpreter = $ExecutionContext.SessionState.InvokeCommand.GetCommand('bash','Application')
    $LanguageName = 'Bash'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Bash")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}




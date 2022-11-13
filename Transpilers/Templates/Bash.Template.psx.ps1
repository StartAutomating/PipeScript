<#
.SYNOPSIS
    Bash Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Bash scripts.

    Heredocs named PipeScript{} will be treated as blocks of PipeScript.

    ```bash
    <<PipeScript{}
    
    # This will be considered PipeScript / PowerShell, and will return the contents of a bash script.

    PipeScript{}
    ```
.EXAMPLE
    Invoke-PipeScript {
        $bashScript = @'
        echo 'hello world'

        <<PipeScript{}
            "echo '$('hi','yo','sup' | Get-Random)'"
        PipeScript{}
    '@
    
        [OutputFile('.\HelloWorld.ps1.sh')]$bashScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.sh
#>
[ValidatePattern('\.sh$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.CommandInfo]
$CommandInfo,

# A dictionary of parameters.
[Collections.IDictionary]
$Parameter,

# A list of arguments.
[PSObject[]]
$ArgumentList
)

begin {
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>\<\<PipeScript\{\})' 
    $endComment   = '(?>PipeScript\{\})'    
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment})"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $endRegex   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
    }
}

process {
    # Add parameters related to the file
    $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
    $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
}

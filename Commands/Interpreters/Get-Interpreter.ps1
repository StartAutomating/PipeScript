function Get-Interpreter {

    <#
    .SYNOPSIS
        Gets Interpreters
    .DESCRIPTION
        Gets PipeScript Interpreters        
    .EXAMPLE
        Get-Interpreter
    .EXAMPLE
        Get-Interpreter -LanguageName "JavaScript"
    .NOTES
        This command accepts open-ended input.
    #>
    [Alias('Get-Interpreters','PSInterpreter','PSInterpreters')]
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The name of one or more languages.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $LanguageName,

    # Any remaining arguments.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Args','Arguments','ArgList')]
    [PSObject[]]
    $ArgumentList,

    # Any input object.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject
    )

    process {
        foreach ($arg in $ArgumentList) {
            if ($arg -is [string] -and $LanguageName -notcontains $arg) {
                $LanguageName += $arg
            }
        }
        
        $myVerb, $myNoun = $MyInvocation.InvocationName -split '-', 2
        if (-not $myNoun) {
            $myNoun = $myVerb
            $myVerb = "Get"
        }

        switch ($myVerb) {
            Get {
                if ($LanguageName) {
            
                    $PSInterpreters[$LanguageName]
                } else {
                    $PSInterpreters
                }
            }
            default {
                foreach ($arg in $ArgumentList) {
                    if ($LanguageName) {
                        $PSInterpreters[$LanguageName]
                    }
                }

                
            }
        }
        
    }

}


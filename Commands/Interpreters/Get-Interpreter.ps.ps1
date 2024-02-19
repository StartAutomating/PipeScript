function Get-Interpreter 
{
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
    [vbn()]
    [string[]]
    $LanguageName,

    # Any remaining arguments.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Args','Arguments','ArgList')]
    [PSObject[]]
    $ArgumentList,

    # Any input object.
    [vfp()]
    [PSObject]
    $InputObject
    )

    process {
        foreach ($arg in $ArgumentList) {
            if ($arg -is [string] -and $LanguageName -notcontains $arg) {
                $LanguageName += $arg
            }
        }
        
        
        if ($LanguageName) {
            foreach ($langName in $LanguageName) {
                if ($PSInterpreters.$langName) {
                    $PSInterpreters.$langName
                }
            }
        } else {
            $PSInterpreters
        }        
    }
}

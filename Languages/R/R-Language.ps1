
function Language.R {
<#
.SYNOPSIS
    R PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate R.

    Because R Scripts only allow single-line comments, this is done using a pair of comment markers.

    # { or # PipeScript{  begins a PipeScript block

    # } or # }PipeScript  ends a PipeScript block

    ~~~r    
    # {

    Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "puts `"$message`""

    # }
    ~~~
.EXAMPLE
    Invoke-PipeScript {
        $rScript = '    
    # {

    Uncommented lines between these two points will be ignored

    #  # Commented lines will become PipeScript / PowerShell.
    # param($message = "hello world")
    # "print(`"$message`")"

    # }
    '
    
        [OutputFile('.\HelloWorld.ps1.r')]$rScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.r
#>
[ValidatePattern('\.r$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern = '\.r$'

    $SingleLineCommentStart = '\#'
    # Any Language can be parsed with a series of regular expresssions.
    # For languages that only support single comments:
    # * The capture group IsSingleLine must be defined.
    # * Whitespace should not be allowed (it makes nested blocks hard to end)
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
    $endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"
        # Using -LinePattern will skip any inline code not starting with #
    $LinePattern   = "^\s{0,}\#\s{0,}"

    # We might have to go looking for R's interpreter
    $interpreter = $(
        # (it may just be in the path)
        if ($ExecutionContext.SessionState.InvokeCommand.GetCommand('RScript', 'Application')) {
            $ExecutionContext.SessionState.InvokeCommand.GetCommand('RScript', 'Application')
        } elseif (
            # Or, if we're on Windows and there's a R ProgramFiles directory
            $IsWindows -and (Test-Path (Join-Path $env:ProgramFiles 'R'))
        ) {
            
            # We can look in there 
            $ExecutionContext.SessionState.InvokeCommand.GetCommand("$(
                Join-Path $env:ProgramFiles 'R' | 
                Get-ChildItem -Directory | 
                # for the most recent version of R
                Sort-Object { ($_.Name -replace '^R-') -as [Version]} -Descending  |  
                Select-Object  -First 1 | 
                Join-Path -ChildPath "bin" |
                Join-Path -ChildPath "RScript.exe"
            )", "Application")
        }
    )
    $LanguageName = 'R'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.R")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}





function Language.JSON {
<#
    .SYNOPSIS
        JSON PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate JSON.

        Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.

        String output from these blocks will be embedded directly.  All other output will be converted to JSON.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        * ```null```
        * ```""```
        * ```{}```
        * ```[]```
    .EXAMPLE
        Invoke-PipeScript {
            a.json template "{
            procs : null/*{Get-Process | Select Name, ID}*/
            }"
        }
    #>
[ValidatePattern('\.json$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
    )

    $FilePattern = '\.json$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$('null', '""', '\{\}', '\[\]' -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    $ForeachObject = {
        $in = $_
        if (($in -is [string]) -or 
            ($in.GetType -and $in.GetType().IsPrimitive)) {
            $in
        } else {
            ConvertTo-Json -Depth 100 -InputObject $in
        }
    }

    # The interpreter for a JSON file is Import-JSON (a function in PipeScript)
    $Interpreter = $(
        $ExecutionContext.SessionState.InvokeCommand.GetCommand('Import-JSON', 'Function')
    )
    $LanguageName = 'JSON'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.JSON")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


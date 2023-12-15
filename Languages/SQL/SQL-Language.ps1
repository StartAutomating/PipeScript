
function Language.SQL {
<#
.SYNOPSIS
    SQL PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate SQL.

    PipeScript can be embedded in multiline or singleline format
    
    In multiline format, PipeScript will be embedded within: `/*{...}*/`
    
    In single line format

    -- { or -- PipeScript{  begins a PipeScript block

    -- } or -- }PipeScript  ends a PipeScript block

    ```SQL    
    -- {

    Uncommented lines between these two points will be ignored

    --  # Commented lines will become PipeScript / PowerShell.
    -- param($message = 'hello world')
    -- "-- $message"
    -- }
    ```
.EXAMPLE
    Invoke-PipeScript {
        $SQLScript = '    
    -- {

    Uncommented lines between these two points will be ignored

    --  # Commented lines will become PipeScript / PowerShell.
    -- param($message = "hello world")
    -- "-- $message"
    -- }
    '
    
        [OutputFile('.\HelloWorld.ps1.sql')]$SQLScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.sql
#>
[ValidatePattern('\.sql$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern = '\.sql$'
    # We start off by declaring a number of regular expressions:
    $startComment = '(?>
        (?>
            (?<IsSingleLine>--)|
            /\*
        )\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>
        --\s{0,}\}\s{0,}(?:PipeScript)?
        |
        \}\*/(?:PipeScript)?\s{0,}
    )    
    '
    $startPattern   = "(?<PSStart>${startComment})"
    $endPattern     = [Regex]::new("(?<PSEnd>${endComment})",'IgnoreCase,IgnorePatternWhitespace')

    # Create a splat containing arguments to the core inline transpiler
    
    # Using -LinePattern will skip any inline code not starting with --
    $LinePattern   = "^\s{0,}--\s{0,}"
    $LanguageName = 'SQL'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.SQL")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}





function Language.Wren {
<#
    .SYNOPSIS
        Wren PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate and interpret [Wren](https://wren.io/).
    .EXAMPLE
        Template.HelloWorld.wren 
    #>

param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    $FilePattern = '\.wren$'

    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $CaseSentitive = $true

    $Interpreter   = 'wren_cli'
    $LanguageName = 'Wren'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Wren")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



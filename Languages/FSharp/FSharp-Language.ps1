[ValidatePattern("(?>FSharp|F\#|Language)[\s\p{P}]")]
param()


function Language.FSharp {
<#
    .SYNOPSIS
        FSharp PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to Generate FSharp        
    #>

param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # FSharp Files are named `.fs`,`.fsi`,`.fsx`, or `.fsscript`.
    $FilePattern = '\.fs(?>i|x|script|)$'

    # FSharp Block Comments Start with `(*`
    $startComment = '\(\*'
    # FSharp Block Comments End with  `*)'
    $endComment   = '\*\)'
    
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    $CaseSensitive = $true
    $LanguageName = 'FSharp'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.FSharp")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



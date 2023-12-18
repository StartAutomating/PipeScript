
function Language.Ruby {
<#
.SYNOPSIS
    Ruby Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Ruby.

    PipeScript can be embedded in a multiline block that starts with ```=begin{``` and ends with } (followed by ```=end```)
#>
[ValidatePattern('\.rb$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    # Ruby files end in .rb
    $FilePattern = '\.rb$'
    
    # Ruby is Case-sensitive
    $CaseSensitive = $true
    
    # Ruby "blocks" are `=begin` and `=end`
    $startComment = '(?>[\r\n]{1,3}\s{0,}=begin[\s\r\n]{0,}\{)'
    $endComment   = '(?>}[\r\n]{1,3}\s{0,}=end)'

    $ignoreEach = '[\d\.]+',
        '""',
        "''"

    $IgnoredContext = "(?<ignore>(?>$($ignoreEach -join '|'))\s{0,}){0,1}"

    # PipeScript source can be embedded within Ruby using `=begin{` `}=end`.
    $startPattern = "(?<PSStart>${IgnoredContext}${startComment})"    
    $endPattern   = "(?<PSEnd>${endComment}${IgnoredContext})"

    # Ruby's interpreter is simply, ruby (if this is not installed, it will error)
    $Interpreter  = 'ruby'
    $LanguageName = 'Ruby'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Ruby")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


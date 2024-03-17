[ValidatePattern("(?>Pug|Language)[\s\p{P}]")]
param()



function Language.Pug {
<#
    .SYNOPSIS
        Pug Language Definition
    .DESCRIPTION
        Allows PipeScript to work with Pug.

        Pug is a high-performance template engine heavily influenced by Haml and implemented with JavaScript for Node.js and browsers.
    #>
[ValidatePattern('\.pug$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()    
    $LanguageName = 'Pug'
    $FilePattern = '\.pug$'
    $IsTemplateLanguage = $true
    $WorksWith = 'Express','React'
    $Install = { npm install pug @args }
    $Website = 'https://pugjs.org/'    
    $startComment = '\<!--'     
    $endComment   = '--\>'    
    $startPattern = "(?<PSStart>$StartComment\{)"    
    $endPattern   = "(?<PSEnd>\}${endComment})"
    $LanguageName = 'Pug'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Pug")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}




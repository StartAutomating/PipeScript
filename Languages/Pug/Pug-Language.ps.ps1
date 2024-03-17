[ValidatePattern("(?>Pug|Language)[\s\p{P}]")]
param()


Language function Pug {
    <#
    .SYNOPSIS
        Pug Language Definition
    .DESCRIPTION
        Allows PipeScript to work with Pug.

        Pug is a high-performance template engine heavily influenced by Haml and implemented with JavaScript for Node.js and browsers.
    #>
    [ValidatePattern('\.pug$')]
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
}


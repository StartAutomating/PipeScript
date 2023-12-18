Language function Liquid {
    <#
    .SYNOPSIS
        Liquid PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate [Liquid](https://shopify.github.io/liquid/)
    #>
    [ValidatePattern("\.liquid$")]
    param()

    # Liquid files have a `.liquid` extension.    
    $FilePattern = '\.liquid$'
    
    # Liquid Comments are `{% comment %}` and `{% endcomment %}`, respectively.
    $StartComment = "\{\%\s{1,}comment\s{1,}\%\}"    
    $EndComment   = "\{\%\s{1,}endcomment\s{1,}\%\}"

    # PipeScript exists within liquid as block encased in a pseudocomment.
    $StartPattern = "\{\%\s{1,}(?>pipescript|\{)"    
    $EndPattern   = "(?>pipescript|\})\s{1,}\%\}"
    
    $Website      = 'https://shopify.github.io/liquid/'
    $ProjectURI   = 'https://github.com/Shopify/liquid'
}

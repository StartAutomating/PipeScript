[ValidatePattern("HTML")]
param()

Template function HTML.StyleSheet {
    <#
    .SYNOPSIS
        Template for a StyleSheet link
    .DESCRIPTION
        A Template for the link to a StyleSheet.    
    #>
    [Alias('Template.Stylesheet.html')]    
    param(
    # The URL of the stylesheet.
    [vbn()]
    [Alias('Uri','Link')]
    [uri]
    $Url
    )

    process {
        if ($url) {
            "<link rel='stylesheet' type='text/css' href='$Url' />"
        }
    }
}

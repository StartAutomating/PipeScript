[ValidatePattern("HTML")]
param()

Template function HTML.Script {
    <#
    .SYNOPSIS
        Template for a Script tag
    .DESCRIPTION
        A Template for the script tag.    
    #>
    [Alias('Template.Script.html')]    
    param(
    # The URL of the script.
    [vbn()]
    [Alias('Uri','Link')]
    [uri]
    $Url,

    # The inline JavaScript.
    [vbn()]
    [Alias('Script')]
    [string]
    $JavaScript,

    # If the script should be loaded asynchronously.
    [vbn()]
    [switch]
    $Async,

    # If the script should not allow EMCA modules
    [vbn()]
    [switch]
    $NoModule,

    # If the script should be deferred.
    [vbn()]
    [switch]
    $Defer,

    # If the script should be blocking.
    [vbn()]
    [switch]
    $Blocking,

    # The fetch priority of the script.
    [vbn()]
    [ValidateSet("high","low","auto")]
    [string]
    $FetchPriority,

    # The cross-origin policy of the script.
    [vbn()]
    [Alias('CORS')]
    [string]
    $CrossOrigin,

    # The integrity value of the script.
    [vbn()]
    [string]
    $Integrity,

    # The nonce value of the script.
    [vbn()]
    [string]
    $Nonce,

    # The referrer policy of the script.
    [vbn()]
    [ValidateSet("no-referrer","no-referrer-when-downgrade",
        "origin","origin-when-cross-origin",
        "same-origin","strict-origin",
        "strict-origin-when-cross-origin","unsafe-url")]
    [string]
    $ReferrerPolicy,

    # The script type
    [vbn()]    
    [string]
    $ScriptType
    )

    process {
        $ScriptAttributes = @(
            if ($async) {"async"}
            if ($defer) {"defer"}
            if ($Blocking) {"blocking"}
            if ($ScriptType) {"type='$ScriptType'"}
            if ($FetchPriority) {"fetchpriority='$($fetchPriority.ToLower())'"}
            if ($ReferrerPolicy) {"referrerpolicy='$($ReferrerPolicy.ToLower())'"}
            if ($CrossOrigin) {"crossorigin='$crossOrigin'"}
            if ($Nonce) {"nonce='$nonce'"}
            if ($Integrity) {"integrity='$integrity'"}            
        ) -join ' '

        if ($url) {
            "<script src='$Url'$(
                if ($ScriptAttributes) {" $ScriptAttributes"}
            )></script>"
        }
        elseif ($JavaScript) {
            "<script$(
                if ($ScriptAttributes) {" $ScriptAttributes"}
            )>$JavaScript</script>"
        }
    }
}
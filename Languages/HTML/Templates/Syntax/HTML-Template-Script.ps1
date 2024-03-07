
function Template.HTML.Script {

    <#
    .SYNOPSIS
        Template for a Script tag
    .DESCRIPTION
        A Template for the script tag.    
    #>
    [Alias('Template.Script.html')]    
    param(
    # The URL of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Uri','Link')]
    [uri]
    $Url,

    # The inline JavaScript.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Script')]
    [string]
    $JavaScript,

    # If the script should be loaded asynchronously.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Async,

    # If the script should not allow EMCA modules
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $NoModule,

    # If the script should be deferred.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Defer,

    # If the script should be blocking.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Blocking,

    # The fetch priority of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet("high","low","auto")]
    [string]
    $FetchPriority,

    # The cross-origin policy of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CORS')]
    [string]
    $CrossOrigin,

    # The integrity value of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Integrity,

    # The nonce value of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Nonce,

    # The referrer policy of the script.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet("no-referrer","no-referrer-when-downgrade",
        "origin","origin-when-cross-origin",
        "same-origin","strict-origin",
        "strict-origin-when-cross-origin","unsafe-url")]
    [string]
    $ReferrerPolicy,

    # The script type
    [Parameter(ValueFromPipelineByPropertyName)]    
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


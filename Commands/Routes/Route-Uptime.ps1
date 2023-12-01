
function Route.Uptime {


    <#
    .SYNOPSIS
        Gets Uptime
    .DESCRIPTION
        A route for getting version uptime
    .EXAMPLE
        Route.Uptime
    #>
    [ValidatePattern(
        "https?://", # We only serve http requests here
        ErrorMessage='$request.uri' # and this applies to $request.uri
    )]    
    [ValidatePattern(
        "/Uptime/?(?>\?|$)", # We only serve requests that end in Uptime 
        ErrorMessage='$request.uri' # and this applies to $request.uri
        )]
    param()

    [DateTime]::Now - ((Get-Process -id $pid).StartTime)


}



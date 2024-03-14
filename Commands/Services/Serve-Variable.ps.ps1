Serve function Variable {
    <#
    .SYNOPSIS
        Serves variables.
    .DESCRIPTION
        Serves variables from a module.
    .NOTES
        This service allows select variables to be served from a module.

        It does not allow for patterns of variables to be served.

        Additionally, it will not allow the variable to be changed (only viewed)
    #>
    [ValidatePattern(        
        '/$($this.Variable -replace "^","\`$?" -join "|")/?', Options ='IgnoreCase,IgnorePatternWhitespace'
    )]
    param(
    # The list of variables to serve
    [vfp(Mandatory)]    
    [PSObject[]]
    $Variable,

    # The module containing the variables.
    [vbn()]
    [PSObject]
    $Module,

    # The request object.
    # This should generally not be provided, as it will be provided by the server.
    # (it can be provided for testing purposes)
    [vbn()]    
    [PSObject]
    $Request
    )

    process {
        return if -not $Module
        return if -not $Request        

        $segments = @($Request.Url.Segments -replace '^/' -replace '/$' -ne '')
        $variableName = $segments[0]
        $gotVariable = $module.SessionState.PSVariable.Get($variableName)

        return if -not $gotVariable
        
        $gotVariable        
    }
}

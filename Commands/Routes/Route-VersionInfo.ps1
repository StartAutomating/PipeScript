
function Route.VersionInfo {


    <#
    .SYNOPSIS
        Gets Version Information
    .DESCRIPTION
        A route for getting version information
    .EXAMPLE
        Route.VersionInfo
    #>
    [ValidatePattern(
        "https?://", # We only serve http requests here
        ErrorMessage='$request.uri' # and this applies to $request.uri
    )]    
    [ValidatePattern(
        "/VersionInfo$", # We only serve requests that end in /VersionInfo 
        ErrorMessage='$request.uri' # and this applies to $request.uri
        )]
    [Reflection.AssemblyMetaData(
        "CacheControl",
        "max-age=86400"
    )]
    param()

    $versionInfo = [Ordered]@{PipeScriptVersion=(Get-Module PipeScript -ErrorAction Ignore).Version}
    foreach ($versionVariable in Get-Variable -Name *Version*) {
        if ($versionVariable.NAme  -notmatch '(?>VersionTable|Version)$') {
            continue
        }
        if ($versionVariable.Value -is [Collections.IDictionary]) {
            foreach ($keyValuePair in $versionVariable.Value.GetEnumerator()) {
                $versionInfo[$keyValuePair.Key] = $keyValuePair.Value
            }                        
        }
        elseif ($versionVariable.Value -as [version]) {
            $versionInfo[$versionVariable.Name] = $versionVariable.Value -as [version]
        }
        elseif ($versionVariable.Name -as [string]) {
            $versionInfo[$versionVariable.Name] = $versionVariable
        }
    }
    [PSCustomObject]$versionInfo


}



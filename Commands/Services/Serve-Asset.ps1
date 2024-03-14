
function Serve.Asset {

    <#
    .SYNOPSIS
        Serves asset files.
    .DESCRIPTION
        Serves asset files.

        These files will not be run, but will be served as static files.
        
        One or more extensions can be provided.
        
        Any file that matches these extensions will be served.
    .NOTES
        This service allows asset files to be served from a module without exposing the file system.        
    #>
    [ValidatePattern(        
        '(?>$($this.Extension -join "|"))$', Options ='IgnoreCase,IgnorePatternWhitespace'
    )]
    param(
    # The list of extensions to serve as assets
    [Parameter(Mandatory,ValueFromPipeline)]    
    [PSObject[]]
    $Extension,

    # The module containing the assets.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $Module,

    # The request object.
    # This should generally not be provided, as it will be provided by the server.
    # (it can be provided for testing purposes)
    [Parameter(ValueFromPipelineByPropertyName)]    
    [PSObject]
    $Request
    )

    process {

        if (-not $module) { return }
        if (-not $request) { return }

        $relativePath = ($Request.Url.Segments -replace '^/' -replace '/$' -ne '') -join [IO.Path]::DirectorySeparatorChar
        $absolutePath = $module | Split-Path | Join-Path -ChildPath $relativePath

        if ($absolutePath -and (Test-Path $absolutePath)) {
            $fileItem = (Get-Item -LiteralPath $absolutePath)
            if ($fileItem.Extension -in $extension) {
                if ($psNode) {
                    #[IO.File]::ReadAllText($fileItem)
                    $psNode.ServeFile($fileItem, $request, $response)
                } else {
                    $fileItem
                }
            }
        }
    }

}



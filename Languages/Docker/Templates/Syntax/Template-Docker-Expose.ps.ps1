Template function Docker.Expose {
    <#
    .SYNOPSIS
        Template for exposing a port in a Dockerfile.
    .DESCRIPTION
        A Template for exposing a port in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#expose
    #>
    param(
    # The port to expose. By default, 80.
    [vbn()]
    [int]
    $Port = 80,

    # The protocol to expose. By default, tcp.
    [ValidateSet('tcp','udp')]
    [string]
    $Protocol = 'tcp'
    )
    
    process {        
        "EXPOSE $Port/$Protocol"
    }
}
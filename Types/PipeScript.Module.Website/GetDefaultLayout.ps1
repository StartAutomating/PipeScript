param()

$this | . {
    param(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Layout','DefaultLayout','BaseLayout')]
    [string]
    $Layout = 'Default'
    )

    process { $Layout }
}

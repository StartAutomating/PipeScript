param()

$this | . {
    param(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('DefaultLayout','BaseLayout')]
    [string]
    $Layout = 'Default'
    )

    process { $Layout }
}

Template function Docker.HealthCheck {
    <#
    .SYNOPSIS
        Template for a health check in a Dockerfile.
    .DESCRIPTION
        A Template for a health check in a Dockerfile.
    .LINK
        https://docs.docker.com/engine/reference/builder/#healthcheck
    #>
    param(
    # The command to run.
    [vbn()]
    [string]
    $Command,

    # The interval between checks.
    [vbn()]
    [timespan]
    $Interval = [Timespan]'00::00:30',

    # The timeout for a check.
    [vbn()]
    [timespan]
    $Timeout = [Timespan]'00::00:30',

    # The start period for the check.
    [vbn()]
    [timespan]
    $StartPeriod = [Timespan]'00::00:00',

    # The start interval for the check.
    [vbn()]
    [timespan]
    $StartInterval = [Timespan]'00::00:05',

    # The number of retries.
    [vbn()]
    [Alias('Retries','Retry')]
    [int]
    $RetryCount = 3
    )

    process {
        $HealthCheckParameters = foreach ($myParameterKeyValue in $PSBoundParameters.GetEnumerator()) {
            if ($myParameterKeyValue.Key -eq 'Command') {
                continue
            }
            "--$($myParameterKeyValue.Key.ToLower() -replace 'start', 'start-') $($myParameterKeyValue.Value.TotalSeconds)"
        }
        "HEALTHCHECK $HealthCheckParameters $Command" -replace '\s{2,}', ' '
    }
}

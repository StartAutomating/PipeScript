
function Template.Docker.HealthCheck {

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
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Command,

    # The interval between checks.
    [Parameter(ValueFromPipelineByPropertyName)]
    [timespan]
    $Interval = [Timespan]'00::00:30',

    # The timeout for a check.
    [Parameter(ValueFromPipelineByPropertyName)]
    [timespan]
    $Timeout = [Timespan]'00::00:30',

    # The start period for the check.
    [Parameter(ValueFromPipelineByPropertyName)]
    [timespan]
    $StartPeriod = [Timespan]'00::00:00',

    # The start interval for the check.
    [Parameter(ValueFromPipelineByPropertyName)]
    [timespan]
    $StartInterval = [Timespan]'00::00:05',

    # The number of retries.
    [Parameter(ValueFromPipelineByPropertyName)]
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



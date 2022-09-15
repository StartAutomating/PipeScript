$TranspilerErrors   = @()
$TranspilerWarnings = @()

$ErrorsAndWarnings  = @{ErrorVariable='TranspilerErrors';WarningVariable='TranspilerWarnings'}
$this | .>PipeScript @ErrorsAndWarnings

if ($TranspilerErrors) {
    $failedMessage = @(
        foreach ($transpilerError in $TranspilerErrors) {
            "$($transpilerError)"
        }
        "$($TranspilerErrors.Count) error(s)"
        if ($transpilerWarnings) {
            "$($TranspilerWarnings.Count) warning(s)"
        }
    ) -join ','
    throw $failedMessage
}
elseif ($TranspilerWarnings) {
    foreach ($TranspilerWarning in $TranspilerWarnings) {
        Write-Warning "$TranspilerWarning "
    }
}

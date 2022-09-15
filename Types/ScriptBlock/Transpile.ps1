$TranspilerErrors   = @()
$TranspilerWarnings = @()

$ErrorsAndWarnings  = @{ErrorVariable='TranspilerErrors';WarningVariable='TranspilerWarnings'}
$this | .>PipeScript @ErrorsAndWarnings

if ($TranspilerErrors) {
    $failedMessage = (@(        
        "$($TranspilerErrors.Count) error(s)"
        if ($transpilerWarnings) {
            "$($TranspilerWarnings.Count) warning(s)"
        }
    ) -join ',') + (@(
        foreach ($transpilerError in $TranspilerErrors) {
            "$($transpilerError | Out-String)"
        }
    ) -join [Environment]::Newline)
    throw $failedMessage
}
elseif ($TranspilerWarnings) {
    foreach ($TranspilerWarning in $TranspilerWarnings) {
        Write-Warning "$TranspilerWarning "
    }
}

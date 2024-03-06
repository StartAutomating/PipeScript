[ValidatePattern("CSharp")]
param()

Template function TryCatch.cs {
    <#
    .SYNOPSIS
        Template for a CSharp try/catch block
    .DESCRIPTION
        Template for try/catch/finally block in CSharp.
    .NOTES
        By default, exceptions are given the variable `e`.

        To change this variable, set -ExceptionVariable
    .EXAMPLE
        Template.TryCatch.cs -Try "something that won't work"
    #>
    [Alias('Template.TryCatchFinally.cs')]    
    param(    
    # The body of the try.    
    [vbn()]
    [Alias('Try')]
    [string[]]
    $Body,    

    # The catch.
    [vbn()]    
    [string[]]
    $Catch,
    
    # The finally.
    [vbn()]
    [Alias('Cleanup','After')]
    [string[]]
    $Finally,

    # The exception variable.  By default `e`.
    [Alias('exv')]
    [string]
    $ExceptionVariable = 'e'
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        if ($catch -match '^\{') {
            $catch = $catch -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        if ($Finally -match '^\{') {
            $Finally = $Finally -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
@"
try {
    $($Body -join (';' + [Environment]::newLine + '    '))
} catch (Exception $exceptionVariable) {
    $($catch -join (';' + [Environment]::newLine + '    '))
}$(if ($Finally) {
" finally {
    $($Finally -join (';' + [Environment]::newLine + '    '))
}"    
})
"@
    }
}



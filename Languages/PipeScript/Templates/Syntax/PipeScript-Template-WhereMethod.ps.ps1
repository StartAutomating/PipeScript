[ValidatePattern('PipeScript')]
param()

Template function PipeScript.WhereMethod {
    <#
    .SYNOPSIS
        Where Method
    .DESCRIPTION
        Where-Object cannot simply run a method with parameters on each object.

        However, we can easily rewrite a Where-Object statement to do exactly that.    
    .EXAMPLE
        { Get-PipeScript | ? CouldPipeType([ScriptBlock]) } | Use-PipeScript
    #>    
    [ValidateScript({
        $validating = $_
        if ($validating -isnot [Management.Automation.Language.CommandAst]) {
            return $false
        }
        if ($validating.CommandElements[0] -notin '?', 'Where', 'Where-Object') {
            return $false
        }
        if ($validating.CommandElements.Count -ne 3) {
            return $false
        }    
        if ($validating.CommandElements[2] -is [Management.Automation.Language.ParenExpressionAst]) {
            return $true
        }
        return $false
        
    })]
    param(
    # The Where-Object Command AST.
    [Parameter(Mandatory,ValueFromPipeline)]
    [Management.Automation.Language.CommandAst]
    $WhereCommandAst
    )

    process {
        # Use multiple assignment to split the command up
        $whereCommand, $whereMethodName, $whereMethod = $whereCommandAst.CommandElements
        # Fix psuedo-empty parenthesis to be properly empty.
        $whereMethod = $whereMethod -replace '\(`$(?>_|null)\)', '()'
        # Create the updated code (don't use Where-Object though, because this will be faster).
        $UpdatedWhereCommand = "& { process { if (`$_.${WhereMethodName}${WhereMethod}) { `$_ } } }"
        # Output the updated script block (and we're done).
        [scriptblock]::Create($UpdatedWhereCommand)
    }
}
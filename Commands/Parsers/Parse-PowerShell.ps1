
function Parse.PowerShell {
    <#
    .SYNOPSIS
        Parses PowerShell
    .DESCRIPTION
        Parses PowerShell, using the abstract syntax tree
    .EXAMPLE
        Get-ChildItem *.ps1 | 
            Parse-PowerShell
    .EXAMPLE
        Parse-PowerShell "'hello world'"
    #>
    [OutputType([Management.Automation.Language.Ast])]
    [Alias('Parse-PowerShell')]
    param(
    # The source.  Can be a string or a file. 
    [Parameter(ValueFromPipeline)]
    [Alias('Text','SourceText','SourceFile')]
    [ValidateScript({
    $validTypeList = [System.String],[System.IO.FileInfo]
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','System.IO.FileInfo'."
    }
    return $true
    })]
    
    [PSObject]    
    $Source
    )
    process {
        if ($Source -is [string]) {
            [ScriptBlock]::Create($Source).Ast
        }
        elseif ($Source -is [IO.FileInfo]) {
            if ($Source.Extension -eq '.ps1') {
                $ExecutionContext.SessionState.InvokeCommand.GetCommand($Source,'ExternalScript').ScriptBlock.Ast
            }            
        }
    }
}



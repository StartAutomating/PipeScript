Parse function PowerShell {
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
    [ValidateTypes(TypeName={[string], [IO.FileInfo]})]
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

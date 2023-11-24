
function Language.ADA {
<#
    .SYNOPSIS
        ADA Language Definition
    .DESCRIPTION
        Defines ADA within PipeScript.
        This allows ADA to be templated.
        
        Because ADA Scripts only allow single-line comments, this is done using a pair of comment markers.
        -- { or -- PipeScript{  begins a PipeScript block
        -- } or -- }PipeScript  ends a PipeScript block                
    .EXAMPLE
        Invoke-PipeScript {
            $AdaScript = '    
        with Ada.Text_IO;
        procedure Hello_World is
        begin
            -- {
            Uncommented lines between these two points will be ignored
            --  # Commented lines will become PipeScript / PowerShell.
            -- param($message = "hello world")        
            -- "Ada.Text_IO.Put_Line (`"$message`");"
            -- }
        end Hello_World;    
        '
        
            [OutputFile('.\HelloWorld.ps1.adb')]$AdaScript
        }
        Invoke-PipeScript .\HelloWorld.ps1.adb
    #>
[ValidatePattern('\.ad[bs]$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'ADA'
    $startComment = '(?>(?<IsSingleLine>--)\s{0,}(?:PipeScript)?\s{0,}\{)'
$endComment   = '(?>--\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})"
$LinePattern   = "^\s{0,}--\s{0,}"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.ADA")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


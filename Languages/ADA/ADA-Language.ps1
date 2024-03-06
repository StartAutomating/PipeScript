[ValidatePattern("(?>ADA|Language)")]
param()


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
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    $FilePattern  = '\.ad[bs]$'
    # Any Language can be parsed with a series of regular expresssions.
    $startComment = '(?>(?<IsSingleLine>--)\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>--\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"
            
    # A language can also declare a `$LinePattern`.  If it does, any inline code that does not match this pattern will be skipped.
    # Using -LinePattern will skip any inline code not starting with --
    $LinePattern   = "^\s{0,}--\s{0,}"
    $LanguageName = 'ADA'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.ADA")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


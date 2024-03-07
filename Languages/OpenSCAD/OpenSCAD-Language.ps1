[ValidatePattern("(?>OpenSCAD|Language)[\s\p{P}]")]
param()


function Language.OpenSCAD {
<#
.SYNOPSIS
    OpenSCAD Language Definition.
.DESCRIPTION
    Allows PipeScript to generate OpenSCAD.
    
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

    The OpenSCAD Inline Transpiler will consider the following syntax to be empty:
    
    * ```"[^"]+"```
    * ```[\d\.]+```
.EXAMPLE
    .> {
        $OpenScadWithInlinePipeScript = @'
Shape = "cube" /*{'"cube"', '"sphere"', '"circle"' | Get-Random}*/;
Size  = 1 /*{Get-Random -Min 1 -Max 100}*/ ;

if (Shape == "cube") {
    cube(Size);
}
if (Shape == "sphere") {
    sphere(Size);
}
if (Shape == "circle") {
    circle(Size);
}
'@

        [OutputFile(".\RandomShapeAndSize.ps1.scad")]$OpenScadWithInlinePipeScript
    }
    
    .> .\RandomShapeAndSize.ps1.scad
#>
[ValidatePattern('\.scad$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern = '\.scad$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$('[\d\.]+','"[^"]+"' -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    $LanguageName = 'OpenSCAD'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.OpenSCAD")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


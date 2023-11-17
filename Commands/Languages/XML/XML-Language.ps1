
function Language.XML {
<#
.SYNOPSIS
    XML Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate XML.
    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.xml$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition =
New-Module {
    
<#
.SYNOPSIS
    XML Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate XML.
    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.xml$')]
param()
    # We start off by declaring a number of regular expressions:
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    
    $ForeachObject = {
        $in = $_
        if (($in -is [string]) -or 
            ($in.GetType -and $in.GetType().IsPrimitive)) {
            $in
        } elseif ($in.ChildNodes) {
            foreach ($inChildNode in $in.ChildNodes) {
                if ($inChildNode.NodeType -ne 'XmlDeclaration') {
                    $inChildNode.OuterXml
                }
            }
        } else {
            $inXml = (ConvertTo-Xml -Depth 100 -InputObject $in)
            foreach ($inChildNode in $inXml.ChildNodes) {
                if ($inChildNode.NodeType -ne 'XmlDeclaration') {
                    $inChildNode.OuterXml
                }
            }
        }
    }
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.XML")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



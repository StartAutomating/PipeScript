
function Language.XSL {
<#
.SYNOPSIS
    XSL PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate and interact with XSL.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.xsl$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    $FilePattern = '\.xsl$'

    # We start off by declaring a number of regular expressions:
    $startComment = '<\!--' # * Start Comments ```<!--```
    $endComment   = '-->'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"

    # XSL will render each output similarily to XML
    $ForeachObject = {
        $in = $_
        # Strings or primitive types are rendered inline
        if (($in -is [string]) -or 
            ($in.GetType -and $in.GetType().IsPrimitive)) {
            $in 
        } elseif ($in.ChildNodes) { # If there were child nodes
            foreach ($inChildNode in $in.ChildNodes) {                
                # output them (unless they were declarations)
                if ($inChildNode.NodeType -ne 'XmlDeclaration') {                    
                    $inChildNode.OuterXml
                }
            }
        } else {
            # otherwise, we attempt to conver the object to xml
            $inXml = (ConvertTo-Xml -Depth 100 -InputObject $in)
            foreach ($inChildNode in $inXml.ChildNodes) {                
                if ($inChildNode.NodeType -ne 'XmlDeclaration') {
                    $inChildNode.OuterXml 
                }
            }
        }
    }
    $LanguageName = 'XSL'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.XSL")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



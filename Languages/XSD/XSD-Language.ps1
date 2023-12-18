
function Language.XSD {
<#
    .SYNOPSIS
        XSD PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate and interpret XSD.
    
        Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
    #>
[ValidatePattern('\.xsd$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
        $FilePattern = '\.xsd$'
        # We start off by declaring a number of regular expressions:
        $startComment = '<\!--' # * Start Comments ```<!--```
        $endComment   = '-->'   # * End Comments   ```-->```
        $Whitespace   = '[\s\n\r]{0,}'
        # * StartPattern     ```$StartComment + '{' + $Whitespace```
        $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
        # * EndPattern       ```$whitespace + '}' + $EndComment```
        $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    
        # XSD Is a Data Language.  It declares information, but does not run code.
        $DataLanguage =  $true
        $CaseSensitive = $true
    
        # The "interpreter" for XSD simply reads each of the files.
        $Interpreter = {        
            foreach ($arg in $args) {
                if (Test-path $arg) {
                    
                    # To read XSD properly, we need to get the file bytes
                    $byteStream = Get-Content $arg -AsByteStream
                    # turn them into a memory stream
                    $memoryStream = [IO.MemoryStream]::new($byteStream)
                    # and read the schema (if this fails, the error will hopefully bubble up)
                    [Xml.Schema.XmlSchema]::Read($memoryStream, {})
                    # Don't forget to close and dispose of the memory stream
                    $memoryStream.Close()
                    $memoryStream.Dispose()
                }
            }
        }
            
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
    $LanguageName = 'XSD'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.XSD")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

    


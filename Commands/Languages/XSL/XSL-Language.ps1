
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

    $Interpreter = {
        param()

        # Remove any empty arguments
        $argList = @($args -ne $null)        
        # And create a transform object
        $xslTransformer = [xml.Xsl.XslCompiledTransform]::new()
        $xslTransformer | Add-Member XslFile $xslFileInfo -Force
        $xslTransformer | Add-Member Arguments $argList -Force

        # Attempt to turn args into XSL-friendly arguments:
        $xslFriendlyArgs = 
            @(foreach ($arg in $argList) {
                if ($arg -match '^\.[\\/]') { # * Resolve relative paths
                    if (Test-path $arg) { # (that exist)
                        (Get-Item $arg).FullName # to their fullname.
                    }
                }
                elseif ($arg -as [xml]) { # * Cast as xml 
                    $arg -as [xml] # if we can
                } else {
                    $arg # or return directly
                }
            })
    
        # The first arg should be the file/xml document
        $xslFile, $otherArgs = $xslFriendlyArgs # the rest should be transform options
        
        try { $xslTransformer.Load($xslFile) }
        catch { 
            $xslTransformer | Add-Member Error $_ -Force

            return $xslTransformer
        }        
        # If we only had the XSL, return the "ready-to-go" transform.
        if ($xslFriendlyArgs.Length -eq 1) {
            return $xslTransformer
        }        

        # If we had one other argument, return a string
        if ($otherArgs.Length -eq 1) {            
            $stringBuilder = [Text.StringBuilder]::new()
            $xmlWriter = [Xml.XmlWriter]::create($stringBuilder)            
            $xslTransformer.Transform($otherArgs[0], $xmlWriter)
            $xmlWriter.Close()
            "$stringBuilder"
        }

        # Invoke the transformer (if this fails, the error will bubble up)
        $xslTransformer.Transform.Invoke($xslFriendlyArgs)    
        
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



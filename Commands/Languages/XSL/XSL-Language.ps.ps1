Language function XSL {
<#
.SYNOPSIS
    XSL PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate and interact with XSL.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.xsl$')]
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
        $xslTransformer | Add-Member XslFile $xslFile -Force
        $otherArgs = @($otherArgs)
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

    function TranslateAssignmentStatement {
        param($assignmentStatement)

        if ($assignmentStatement.Right.Expression -is [Management.Automation.Language.StringConstantExpressionAst] -and 
            $assignmentStatement.Operator -eq 'Equals') {
            "<xsl:variable name=`"$($assignmentStatement.Left)`">$($assignmentStatement.Right.Expression.Value)</xsl:variable>"
        }
    }

    function TranslateIfStatement {
        param($ifStatement)

        if ($ifStatement.Clauses.Count -eq 1 -and -not $ifStatement.ElseClause){
@"
<xsl:if test="$(
    $this.TranslateFromPowerShell($ifStatement.Clauses.Item1) -replace '"', '\"'
)">
$($this.TranslateFromPowerShell($ifStatement.Clauses.Item2) -replace '"', '\"')
</xsl:if>
"@
        }
        else 
        {
@"
<xsl:choose>$(
    @(
    foreach ($ifClause in $ifStatement.Clauses) {
        "<xsl:when test=`"$(
            $this.TranslateFromPowerShell($ifClause.Item1) -replace '"', '\"'
        )`">
        $($this.TranslateFromPowerShell($ifClause.Item2) -replace '"', '\"')
        </xsl:when>"
    }
    if ($ifStatement.ElseClause) {
        "<xsl:otherwise>$($this.TranslateFromPowerShell($ifClause.Item2) -replace '"', '\"')</xsl:otherwise>"
    }
    ) -join ((' ' * 4) + [Environment]::NewLine)
)</xsl:choose>
"@
        }
    }
}

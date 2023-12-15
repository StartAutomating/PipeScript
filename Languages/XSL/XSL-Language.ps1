
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
        
        $xslTransformer | Add-Member Arguments $argList -Force

        # Attempt to turn args into XSL-friendly arguments:
        $xslFriendlyArgs = 
            @(foreach ($arg in $argList) {
                if ($arg -match '^\.[\\/]') { # * Resolve relative paths
                    if (Test-path $arg) { # (that exist)
                        (Get-Item $arg).FullName # to their fullname.
                    }
                    else {
                        "$($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($arg))"
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
            return "$stringBuilder"            
        }

        # Invoke the transformer (if this fails, the error will bubble up)
        $xslTransformer.Transform.Invoke($otherArgs)    
        
    }

    function TranslateAssignmentStatement {
    
            param($assignmentStatement)
    
            if ($assignmentStatement.Right.Expression -is [Management.Automation.Language.StringConstantExpressionAst] -and 
                $assignmentStatement.Operator -eq 'Equals') {
                "<xsl:variable name=`"$($assignmentStatement.Left)`">$($assignmentStatement.Right.Expression.Value)</xsl:variable>"
            }
        
    }

    function TranslateSwitchStatement {
    
            param($switchStatement)
    
    @"
<xsl:variable name='`$_'>$($this.TranslateFromPowerShell($switchStatement.Condition))</xsl:variable>
<xsl:choose>$(
    @(
    foreach ($switchClause in $switchStatement.Clauses) {
        "<xsl:when test=`"$(
            $this.TranslateFromPowerShell($switchClause.Item1) -replace '"', '\"'
        )`">
        $($this.TranslateFromPowerShell($switchClause.Item2) -replace '"', '\"')
        </xsl:when>"
    }
    if ($switchStatement.Default) {
        "<xsl:otherwise>$($this.TranslateFromPowerShell($switchStatement.Default) -replace '"', '\"')</xsl:otherwise>"
    }
    ) -join ((' ' * 4) + [Environment]::NewLine)
)</xsl:choose>
"@
        
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

    function TranslateForeachStatement {
    
            param($ForeachStatementAst)
    
            @"
<xsl:for-each select="$(
    $this.TranslateFromPowerShell($ForeachStatementAst.Condition) -replace '"', '\"'
)">
<xsl:variable name='$($ForeachStatementAst.Variable.VariablePath.UserPath)' select='.' />
$($this.TranslateFromPowerShell($ForeachStatementAst.Body) -replace '"', '\"')
</xsl:for-each>
"@
    
        
    }

    function TranslateFromPowerShell {
    
            <#
            .SYNOPSIS
                Performs Limited PowerShell to XSL Translation
            .DESCRIPTION
                Performs Limited PowerShell to XSL Translation.
    
                While XSL is a much more restricted language than PowerShell, certain statements translate fairly cleanly:
    
                |Powershell|XSL|
                |-|-|
                |`foreach`|`<xsl:for-each />`/`<xsl:variable />`|
                |`if|`<xsl:if />`/`<xls:choose />`/`<xsl:otherwise />|
                |`switch`|`<xsl:choose>`|
                |`Sort-Object|`<xsl:sort/>`|
                
                String Constants can be embedded inline.            
    
            .EXAMPLE
                $PSLanguage.XSL.TranslateFromPowerShell({if($x -eq "true") { "y" })            
            #>
            param($inputObject)
    
            if (-not $inputObject) { return }
    
            switch ($inputObject) {
            {$_ -is [Management.Automation.Language.CommandExpressionAst]}
            {
                            $this.TranslateFromPowerShell($inputObject.Expression)
                        }
            {$_ -is [Management.Automation.Language.CommandAst]}
            {
            
                        }
            {$_ -is [Management.Automation.Language.PipelineAst]}
            {
                            foreach ($element in $inputObject.PipelineElements) {
                                $this.TranslateFromPowerShell($element)
                            }
                        }
            {$_ -is [Management.Automation.Language.StatementBlockAst]}
            {
                            foreach ($statement in $inputObject.Statements) {
                                $this.TranslateFromPowerShell($statement)
                            }
                        }
            {$_ -is [Management.Automation.Language.ForeachStatementAst]}
            {
                            $foreachStatement = $_
                            $this.TranslateForeachStatement($foreachStatement)
                        }
            {$_ -is [Management.Automation.Language.IfStatementAst]}
            {
                            $ifStatement = $_
                            $this.TranslateIfStatement($ifStatement)
                        }
            {$_ -is [Management.Automation.Language.StringConstantExpressionAst]}
            {
                            $_.Value
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



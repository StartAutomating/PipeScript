[ValidatePattern("(?>SVG|Language)[\s\p{P}]")]
param()

Language function SVG {
<#
.SYNOPSIS
    SVG PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate SVG.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
.EXAMPLE
    $starsTemplate = Invoke-PipeScript {
        Stars.svg template '
            <!--{
                Invoke-RestMethod https://pssvg.start-automating.com/Examples/Stars.svg
            }-->
        '
    }
    
    $starsTemplate.Save("$pwd\Stars.svg")
#>
[ValidatePattern('\.svg$')]
param()
    # SVG files end in `.svg`

    $FilePattern  = '\.svg$'
    
    # They use HTML/XML style comments:
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
    
    # SVG is a data language (event attributes only auto-wire within a browser)
    $DataLanguage = $true

    # SVG is case-sensitive.
    $CaseSensitive = $true

    # The "interpreter" for SVG simply reads each of the files.
    $Interpreter = {        
        $xmlFiles = @(foreach ($arg in $args) {
            if (Test-path $arg) {                
                [IO.File]::ReadAllText($arg) -as [xml]
            }
            else {
                $otherArgs += $arg
            }
        })
        
        $xmlFiles
    }

}

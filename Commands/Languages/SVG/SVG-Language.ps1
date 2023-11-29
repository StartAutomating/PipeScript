
function Language.SVG {
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
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()
    $FilePattern  = '\.svg$'
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
    
    # SVG is a data language (event attributes only auto-wire within a browser)
    $IsDataLanguage = $true

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
    $LanguageName = 'SVG'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.SVG")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}



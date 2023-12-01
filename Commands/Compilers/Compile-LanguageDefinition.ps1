
function Compile.LanguageDefinition {


    <#
    .SYNOPSIS
        Compiles a language definition 
    .DESCRIPTION
        Compiles a language definition.
        
        Language definitions integrate languages into PipeScript, so that they can be templated, interpreted, and compiled.
    .NOTES        
        Language definitions are an open-ended object.

        By providing key properties or methods, a language can support a variety of scenarios.

        |Scenario|Required Properties|
        |-|-|
        |Templating    | `.StartPattern`, `.EndPattern`|
        |Interpretation| `.Interpreter`                |

        Language definitions should not contain named blocks.
    .EXAMPLE
        Import-PipeScript {         
            language function TestLanguage {
                $AnyVariableInThisBlock = 'Will Become a Property'
            }
        }
    #>
    [Alias('PostProcess-LanguageDefinition')]
    [ValidateScript({
        $validating = $_
        if ($validating -is [Management.Automation.Language.FunctionDefinitionAst]) {
            return $validating.Name -match '^Language'
        }
        return $false
    })]
    [OutputType(
        [ScriptBlock],
        [Management.Automation.Language.FunctionDefinitionAst]
    )]
    param(
    # A Language Definition, as a Script Block
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline)]
    [Alias('ScriptBlock','Definition')]
    [ScriptBlock]
    $LanguageDefinition,

    # A Language Function Definition
    [Parameter(Mandatory,ParameterSetName='FunctionDefinition',ValueFromPipeline)]
    [Management.Automation.Language.FunctionDefinitionAst]
    $LanguageFunctionAst
    )

    begin { $myCmd = $MyInvocation.MyCommand}

    process {
        switch ($PSCmdlet.ParameterSetName) {
            ScriptBlock {
                $newScriptLines = @(                    
                    "`New-Module {"                    
                    "    $LanguageDefinition"
                    "    Export-ModuleMember -Variable * -Function * -Alias *"
                    "} -AsCustomObject"
                )

                [ScriptBlock]::Create($newScriptLines -join [Environment]::NewLine)
            }
            FunctionDefinition {
                if ($LanguageFunctionAst.Name -notmatch '^Language\p{P}') { return }
                $newScriptLines = @(
                    $languageName = $LanguageFunctionAst.Name -replace '^Language\p{P}'
                    '$this = $myInvocation.MyCommand'
                    'if (-not $this.Self) {'
                    '$languageDefinition = New-Module {'                    
                    "    $($LanguageFunctionAst.Body.EndBlock)"
                    "    `$LanguageName = '$languageName'"
                    "    Export-ModuleMember -Variable * -Function * -Alias *"
                    "} -AsCustomObject"                    
                    '$languageDefinition.pstypenames.clear()'
                    '$languageDefinition.pstypenames.add("Language")'
                    '$languageDefinition.pstypenames.add("Language.' + $languageName + '")'
                    '$this.psobject.properties.add([PSNoteProperty]::new(''Self'',$languageDefinition))'
                    '}'
                    '$this.Self'
                )                
                
                $newFunctionDefinition = @(if ($LanguageFunctionAst.IsFilter) {
                    "filter", $LanguageFunctionAst.Name, '{' -join ' '
                } else {
                    "function", $LanguageFunctionAst.Name, '{' -join ' '
                }
                $blockComments = @([Regex]::New("
\<\# # The opening tag
(?<Block>
    (?:.|\s)+?(?=\z|\#>) # anything until the closing tag
)
\#\> # the closing tag
", 'IgnoreCase,IgnorePatternWhitespace', '00:00:01').Matches($LanguageFunctionAst.Body.Extent)) -as [Text.RegularExpressions.Match[]]
                if ($blockComments) {
                    $blockComments[0]                    
                }
                $LanguageFunctionAst.Body.ParamBlock.Attributes -join [Environment]::NewLine
                'param()'
                $newScriptLines
                "}") -join [Environment]::NewLine
                
                [ScriptBlock]::Create($newFunctionDefinition).Ast.EndBlock.Statements[0]
            }            
        }
        
    }


}



<#
.SYNOPSIS
    Regex Literal Transpiler
.DESCRIPTION
    Allows for Regex Literals within PipeScript.

    Regex Literals are strings enclosed within slashes.

    The ending slash may be followed by ```[Text.RegularExpressions.RegexOptions]```.
.Example
    {
        '/[a|b]/'
    } | .>PipeScript
.EXAMPLE
    {
        "/[$a|$b]/"
    } | .>PipeScript
.EXAMPLE
    {@'
/
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?<indent>\s{0,1})
/
'@
    } | .>PipeScript

.EXAMPLE
    {
        $Keywords = "looking", "for", "these", "words"
        @"
/
# Double quoted heredocs can still contain variables
[\s\p{P}]{0,1}         # Whitespace or punctuation
$($Keywords -join '|') # followed by keywords
[\s\p{P}]{0,1}         # followed by whitespace or punctuation
/
"@
    } | .>PipeScript
#>
[ValidatePattern(@'
^                             # Start anchor
(?<HereDoc>@){0,1}            # Optional heredoc start
['`"]                         # String start
(?(HereDoc)([\r\n]{1,2}))     # If we found a heredoc, the next portion of the match must be 1-2 newlines/carriage returns
/                             # Followed by a slash
'@, Options='IgnoreCase,IgnorePatternWhitespace')]
[ValidatePattern(@'
/                             # closing slash
(?<Options>[\w,]+){0,1}       # optional options
(?(HereDoc)([\r\n]{1,2}))     # If we found a heredoc, the next portion of the match must be 1-2 newlines/carriage returns
['`"]
(?<HereDoc>@){0,1}            # Optional heredoc end
$                        # string end.     
'@, Options='IgnoreCase,IgnorePatternWhitespace, RightToLeft')]
param(
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='StringConstantExpressionAST')]
[Management.Automation.Language.StringConstantExpressionAST]
$StringConstantExpression,

[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ExpandableStringExpressionAst')]
[Management.Automation.Language.ExpandableStringExpressionAst]
$ExpandableStringExpression
)

begin {
    $startRegex, $endRegex, $null =
        foreach ($attr in $MyInvocation.MyCommand.ScriptBlock.Attributes) {
            if (-not $attr.RegexPattern) {
                continue
            }
            [Regex]::new($attr.RegexPattern, $attr.Options)
        }
}

process {
    
    $StringExpr, $stringType = 
        if ($StringConstantExpression ) {
            $StringConstantExpression.Extent.ToString(), $StringConstantExpression.StringConstantType
        } else {
            $ExpandableStringExpression.Extent.ToString(), $ExpandableStringExpression.StringConstantType
        }

    $sparseStringExpr = $StringExpr -replace $startRegex -replace $endRegex
    $null = $StringExpr -match $endRegex
    $stringStart, $stringEnd = 
        if ($stringType -eq 'SingleQuotedHereString') {
            "@'" + [Environment]::NewLine
            [Environment]::NewLine + "'@"
        }
        elseif ($stringType -eq 'DoubleQuotedHereString') {
            '@"' + [Environment]::NewLine
            [Environment]::NewLine + '"@'
        }
        elseif ($stringType -eq 'SingleQuoted' ) {
            "'"
            "'"
        }
        elseif ($stringType -eq 'DoubleQuoted') {
            '"'
            '"'
        }

    $recreatedString = $stringStart + $sparseStringExpr  + $stringEnd
    $optionStr = 
        if ($matches.Options) {
            "'$($matches.Options)'"
        }
        else {       
            if ($stringType -like '*here*') {
                "'IgnorePatternWhitespace,IgnoreCase'"
            } else {
                "'IgnoreCase'"
            }
        }
    
    [scriptblock]::Create("[regex]::new($recreatedString, $optionStr)")
}
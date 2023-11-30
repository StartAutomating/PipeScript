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

    # This will become:

    [regex]::new('[a|b]', 'IgnoreCase')
.EXAMPLE
    Invoke-PipeScript {
        '/[a|b]/'.Matches('ab')
    }
.EXAMPLE
    {
        "/[$a|$b]/"
    } | .>PipeScript

    # This will become:

    [regex]::new("[$a|$b]", 'IgnoreCase')
.EXAMPLE
    {
@'
/
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?<indent>\s{0,1})
/
'@
    } | .>PipeScript

    # This will become:

    [regex]::new(@'
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?<indent>\s{0,1})
'@, 'IgnorePatternWhitespace,IgnoreCase')    

.EXAMPLE
    $Keywords = "looking", "for", "these", "words"

    {
@"
/
# Double quoted heredocs can still contain variables
[\s\p{P}]{0,1}         # Whitespace or punctuation
$($Keywords -join '|') # followed by keywords
[\s\p{P}]{0,1}         # followed by whitespace or punctuation
/
"@
    } | .>PipeScript


    # This will become:

    [regex]::new(@"
# Double quoted heredocs can still contain variables
[\s\p{P}]{0,1}         # Whitespace or punctuation
$($Keywords -join '|') # followed by keywords
[\s\p{P}]{0,1}         # followed by whitespace or punctuation
"@, 'IgnorePatternWhitespace,IgnoreCase')
#>
[ValidatePattern(@'
^                             # Start anchor
(?<HereDoc>@){0,1}            # Optional heredoc start
['`"]                         # String start
(?(HereDoc)([\r\n]{1,2}))     # If we found a heredoc, the next portion of the match must be 1-2 newlines/carriage returns
/
'@, Options='IgnoreCase,IgnorePatternWhitespace')]
[ValidatePattern(@'
/                             # a closing slash
(?<Options>[\w,]+){0,1}       # optional options
(?(HereDoc)([\r\n]{1,2}))     # If we found a heredoc, the next portion of the match must be 1-2 newlines/carriage returns
['`"]
(?<HereDoc>@){0,1}            # Optional heredoc end
$                        # string end.     
'@, Options='IgnoreCase,IgnorePatternWhitespace, RightToLeft')]
[ValidateScript({
    $validating = $_
    if ($validating.Parent -is [Management.Automation.Language.AttributeAST]) {
        return $false
    }
    
    # If we're invoking a member and we are not the expression being invoked, we're invalid.
    if ($validating.Parent -is [Management.Automation.Language.InvokeMemberExpressionAst] -and 
        $validating.Parent.Expression -ne $validating) {
        return $false
    }

    # If we're a command parameter
    if ($validating.Parent -is [Management.Automation.Language.CommandAst]) {
        return $false # return false
    }

    # If we're validating a command
    if ($validating -is [Management.Automation.Language.CommandAst]) {
        # return false.
        return $false
    }

    # If the parent is an array or subexpression
    if (
        $validating.Parent -is [Management.Automation.Language.ArrayLiteralAst] -or 
        $validating.Parent -is [Management.Automation.Language.SubexpressionAst] -or 
        $validating.Parent -is [Management.Automation.Language.ArrayExpressionAst]
    ) {
        return $false # return false.
    }
    return $true
})]
param(
# A RegexLiteral can be any string constant expression (as long as it's not in an attribute).
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='StringConstantExpressionAST')]
[Management.Automation.Language.StringConstantExpressionAST]
$StringConstantExpression,

# It can also by any expandable string, which allows you to construct Regexes using PowerShell variables and subexpressions.
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

    
    $sparseStringExpr = $StringExpr -replace $endRegex -replace $startRegex
    if ($sparseStringExpr -match '^@{0,1}["'']') {
        return
    }
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
        if ($matches.Options -and $matches.Options -as [Text.RegularExpressions.RegexOptions]) {
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
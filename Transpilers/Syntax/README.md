This directory and it's subdirectories contain syntax changes that enable common programming scenarios in PowerShell and PipeScript.


|DisplayName                               |Synopsis                                              |
|------------------------------------------|------------------------------------------------------|
|[PipedAssignment](PipedAssignment.psx.ps1)|[Piped Assignment Transpiler](PipedAssignment.psx.ps1)|
|[RegexLiteral](RegexLiteral.psx.ps1)      |[Regex Literal Transpiler](RegexLiteral.psx.ps1)      |




## PipedAssignment Example 1


~~~PowerShell
    {
        $Collection |=| Where-Object Name -match $Pattern
    } | .>PipeScript

    # This will become:

    $Collection = $Collection | Where-Object Name -match $pattern
~~~

## PipedAssignment Example 2


~~~PowerShell
    {
        $Collection |=| Where-Object Name -match $pattern | Select-Object -ExpandProperty Name
    } | .>PipeScript

    # This will become

    $Collection = $Collection |
            Where-Object Name -match $pattern |
            Select-Object -ExpandProperty Name
~~~

## RegexLiteral Example 1


~~~PowerShell
    {
        '/[a|b]/'
    } | .>PipeScript
~~~

## RegexLiteral Example 2


~~~PowerShell
    {
        "/[$a|$b]/"
    } | .>PipeScript
~~~

## RegexLiteral Example 3


~~~PowerShell
    {@'
/
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?<indent>\s{0,1})
/
'@
    } | .>PipeScript
~~~

## RegexLiteral Example 4


~~~PowerShell
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
~~~


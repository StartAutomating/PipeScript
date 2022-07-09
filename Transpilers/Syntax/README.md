This directory and it's subdirectories contain syntax changes that enable common programming scenarios in PowerShell and PipeScript.


|DisplayName                               |Synopsis                                              |
|------------------------------------------|------------------------------------------------------|
|[Dot](Dot.psx.ps1)                        |[Dot Notation](Dot.psx.ps1)                           |
|[PipedAssignment](PipedAssignment.psx.ps1)|[Piped Assignment Transpiler](PipedAssignment.psx.ps1)|
|[RegexLiteral](RegexLiteral.psx.ps1)      |[Regex Literal Transpiler](RegexLiteral.psx.ps1)      |




## Dot Example 1


~~~PowerShell
    .> {
        [DateTime]::now |
~~~

## Dot Example 2


~~~PowerShell
    .> {
        "abc", "123", "abc123" |
~~~

## Dot Example 3


~~~PowerShell
    .> { 1
~~~

## Dot Example 4


~~~PowerShell
    .> { 1
~~~

## Dot Example 5


~~~PowerShell
    .> { 1.
~~~

## Dot Example 6


~~~PowerShell
    .> {
~~~

## Dot Example 7


~~~PowerShell
    .> {
        # Declare a new object
~~~

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

    # This will become:

    [regex]::new('[a|b]', 'IgnoreCase')
~~~

## RegexLiteral Example 2


~~~PowerShell
    Invoke-PipeScript {
        '/[a|b]/'
~~~

## RegexLiteral Example 3


~~~PowerShell
    {
        "/[$a|$b]/"
    } | .>PipeScript

    # This will become:

    [regex]::new("[$a|$b]", 'IgnoreCase')
~~~

## RegexLiteral Example 4


~~~PowerShell
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
~~~

## RegexLiteral Example 5


~~~PowerShell
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
~~~


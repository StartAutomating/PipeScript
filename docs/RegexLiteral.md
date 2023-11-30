RegexLiteral
------------

### Synopsis
Regex Literal Transpiler (currently disabled)

---

### Description

Allows for Regex Literals within PipeScript.

Regex Literals are strings enclosed within slashes.

The ending slash may be followed by ```[Text.RegularExpressions.RegexOptions]```.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    '/[a|b]/'
} | .>PipeScript
# This will become:

[regex]::new('[a|b]', 'IgnoreCase')
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript {
    '/[a|b]/'.Matches('ab')
}
```
> EXAMPLE 3

```PowerShell
{
    "/[$a|$b]/"
} | .>PipeScript
# This will become:

[regex]::new("[$a|$b]", 'IgnoreCase')
```
> EXAMPLE 4

```PowerShell
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
```
> EXAMPLE 5

```PowerShell
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
```

---

### Parameters
#### **StringConstantExpression**
A RegexLiteral can be any string constant expression (as long as it's not in an attribute).

|Type                           |Required|Position|PipelineInput |
|-------------------------------|--------|--------|--------------|
|`[StringConstantExpressionAst]`|true    |named   |true (ByValue)|

#### **ExpandableStringExpression**
It can also by any expandable string, which allows you to construct Regexes using PowerShell variables and subexpressions.

|Type                             |Required|Position|PipelineInput |
|---------------------------------|--------|--------|--------------|
|`[ExpandableStringExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
RegexLiteral -StringConstantExpression <StringConstantExpressionAst> [<CommonParameters>]
```
```PowerShell
RegexLiteral -ExpandableStringExpression <ExpandableStringExpressionAst> [<CommonParameters>]
```

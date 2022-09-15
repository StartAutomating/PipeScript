
RegexLiteral
------------
### Synopsis
Regex Literal Transpiler

---
### Description

Allows for Regex Literals within PipeScript.

Regex Literals are strings enclosed within slashes.

The ending slash may be followed by ```[Text.RegularExpressions.RegexOptions]```.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    &#39;/[a|b]/&#39;
} | .&gt;PipeScript
```
# This will become:

[regex]::new('[a|b]', 'IgnoreCase')
#### EXAMPLE 2
```PowerShell
Invoke-PipeScript {
    &#39;/[a|b]/&#39;.Matches(&#39;ab&#39;)
}
```

#### EXAMPLE 3
```PowerShell
{
    &quot;/[$a|$b]/&quot;
} | .&gt;PipeScript
```
# This will become:

[regex]::new("[$a|$b]", 'IgnoreCase')
#### EXAMPLE 4
```PowerShell
{
@&#39;
/
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?&lt;indent&gt;\s{0,1})
/
&#39;@
} | .&gt;PipeScript
```
# This will become:

[regex]::new(@'
# Heredocs Regex literals will have IgnorePatternWhitespace by default, which allows comments
^ # Match the string start
(?<indent>\s{0,1})
'@, 'IgnorePatternWhitespace,IgnoreCase')
#### EXAMPLE 5
```PowerShell
$Keywords = &quot;looking&quot;, &quot;for&quot;, &quot;these&quot;, &quot;words&quot;
```
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
---
### Parameters
#### **StringConstantExpression**

> **Type**: ```[StringConstantExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **ExpandableStringExpression**

> **Type**: ```[ExpandableStringExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
RegexLiteral -StringConstantExpression &lt;StringConstantExpressionAst&gt; [&lt;CommonParameters&gt;]
```
```PowerShell
RegexLiteral -ExpandableStringExpression &lt;ExpandableStringExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---




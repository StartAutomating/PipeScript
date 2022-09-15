
PipeScript.AttributedExpression
-------------------------------
### Synopsis
The PipeScript AttributedExpression Transpiler

---
### Description

AttributedExpressions will be transpiled 

AttributedExpressions often apply to variables, for instance:

```PowerShell
$hello = 'hello world'
[OutputFile(".\Hello.txt")]$hello
```PowerShell

---
### Parameters
#### **AttributedExpressionAst**

The attributed expression



> **Type**: ```[AttributedExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
PipeScript.AttributedExpression -AttributedExpressionAst &lt;AttributedExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---




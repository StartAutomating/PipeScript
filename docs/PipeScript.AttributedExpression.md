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

|Type                       |Required|Position|PipelineInput |
|---------------------------|--------|--------|--------------|
|`[AttributedExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.AttributedExpression -AttributedExpressionAst <AttributedExpressionAst> [<CommonParameters>]
```

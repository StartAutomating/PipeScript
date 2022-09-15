
Search-PipeScript
-----------------
### Synopsis
Searches PowerShell and PipeScript ScriptBlocks

---
### Description

Searches PowerShell and PipeScript ScriptBlocks, files, and text

---
### Related Links
* [Update-PipeScript](Update-PipeScript.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Search-PipeScript -ScriptBlock {
    $a
    $b
    $c
    &quot;text&quot;
} -AstType Variable
```

---
### Parameters
#### **InputObject**

The ScriptBlock that will be searched.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **AstCondition**

The AST Condition.
These Script Blocks



> **Type**: ```[ScriptBlock[]]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **AstType**

A shortname for the abstract syntax tree types.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **RegularExpression**

One or more regular expressions to match.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **Recurse**

If set, will search nested script blocks.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
Search.PipeScript.Result


---
### Syntax
```PowerShell
Search-PipeScript [[-InputObject] &lt;Object&gt;] [[-AstCondition] &lt;ScriptBlock[]&gt;] [[-AstType] &lt;Object&gt;] [[-RegularExpression] &lt;Object&gt;] [-Recurse] [&lt;CommonParameters&gt;]
```
---



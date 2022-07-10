
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
    "text"
} -AstType Variable
```

---
### Parameters
#### **InputObject**

The ScriptBlock that will be searched.



|Type          |Requried|Postion|PipelineInput                 |
|--------------|--------|-------|------------------------------|
|```[Object]```|false   |1      |true (ByValue, ByPropertyName)|
---
#### **AstCondition**

The AST Condition.
These Script Blocks



|Type                 |Requried|Postion|PipelineInput        |
|---------------------|--------|-------|---------------------|
|```[ScriptBlock[]]```|false   |2      |true (ByPropertyName)|
---
#### **AstType**

A shortname for the abstract syntax tree types.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Object]```|false   |3      |true (ByPropertyName)|
---
#### **RegularExpression**

One or more regular expressions to match.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Object]```|false   |4      |true (ByPropertyName)|
---
### Outputs
Search.PipeScript.Result


---
### Syntax
```PowerShell
Search-PipeScript [[-InputObject] <Object>] [[-AstCondition] <ScriptBlock[]>] [[-AstType] <Object>] [[-RegularExpression] <Object>] [<CommonParameters>]
```
---



Search-PipeScript
-----------------

### Synopsis
Searches PowerShell and PipeScript ScriptBlocks

---

### Description

Searches the contents of PowerShell and PipeScript ScriptBlocks, files, and text.

Search-PipeScript can search using an -ASTCondition -or -ASTType or with a -RegularExpression.

---

### Related Links
* [Update-PipeScript](Update-PipeScript.md)

---

### Examples
> EXAMPLE 1

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
The input to search.
This can be a `[string]`, `[ScriptBlock]`, `[IO.FileInfo]`, or `[Ast]`.

|Type      |Required|Position|PipelineInput                 |Aliases             |
|----------|--------|--------|------------------------------|--------------------|
|`[Object]`|false   |1       |true (ByValue, ByPropertyName)|ScriptBlock<br/>Text|

#### **AstCondition**
The AST Condition.
These conditions will apply when the input is a `[ScriptBlock]`, `[Ast]`, or PowerShell file.

|Type             |Required|Position|PipelineInput        |Aliases    |
|-----------------|--------|--------|---------------------|-----------|
|`[ScriptBlock[]]`|false   |2       |true (ByPropertyName)|ASTDelegate|

#### **AstType**
A shortname for the abstract syntax tree types.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|false   |3       |true (ByPropertyName)|

#### **RegularExpression**
One or more regular expressions to match.

|Type      |Required|Position|PipelineInput        |Aliases                                 |
|----------|--------|--------|---------------------|----------------------------------------|
|`[Object]`|false   |4       |true (ByPropertyName)|RegEx<br/>Regexes<br/>RegularExpressions|

#### **Recurse**
If set, will search nested script blocks.

|Type      |Required|Position|PipelineInput|Aliases                |
|----------|--------|--------|-------------|-----------------------|
|`[Switch]`|false   |named   |false        |SearchNestedScriptBlock|

---

### Outputs
* Search.PipeScript.Result

---

### Syntax
```PowerShell
Search-PipeScript [[-InputObject] <Object>] [[-AstCondition] <ScriptBlock[]>] [[-AstType] <Object>] [[-RegularExpression] <Object>] [-Recurse] [<CommonParameters>]
```

Parse.CSharp
------------

### Synopsis
Parses CSharp

---

### Description

Parses CSharp using Microsoft.CodeAnalysis

---

### Examples
> EXAMPLE 1

```PowerShell
Parse-CSharp -Source '"hello world";'
```

---

### Parameters
#### **Source**
The source.  Can be a string or a file.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |1       |true (ByValue)|

---

### Outputs
* Microsoft.CodeAnalysis.SyntaxTree

---

### Syntax
```PowerShell
Parse.CSharp [[-Source] <PSObject>] [<CommonParameters>]
```

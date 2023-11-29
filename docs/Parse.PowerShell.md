Parse.PowerShell
----------------

### Synopsis
Parses PowerShell

---

### Description

Parses PowerShell, using the abstract syntax tree

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ChildItem *.ps1 | 
    Parse-PowerShell
```
> EXAMPLE 2

```PowerShell
Parse-PowerShell "'hello world'"
```

---

### Parameters
#### **Source**
The source.  Can be a string or a file.

|Type        |Required|Position|PipelineInput |Aliases                                           |
|------------|--------|--------|--------------|--------------------------------------------------|
|`[PSObject]`|false   |1       |true (ByValue)|Text<br/>SourceText<br/>SourceFile<br/>InputObject|

---

### Outputs
* [Management.Automation.Language.Ast](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.Language.Ast)

---

### Syntax
```PowerShell
Parse.PowerShell [[-Source] <PSObject>] [<CommonParameters>]
```

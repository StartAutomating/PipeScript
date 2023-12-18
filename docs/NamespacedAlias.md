NamespacedAlias
---------------

### Synopsis
Declares a namespaced alias

---

### Description

Declares an alias in a namespace.

Namespaces are used to logically group functionality in a way that can be efficiently queried.

---

### Examples
> EXAMPLE 1

```PowerShell
. {
    PipeScript.Template alias .\Transpilers\Templates\*.psx.ps1
}.Transpile()
```

---

### Parameters
#### **CommandAst**
The CommandAST that will be transformed.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
NamespacedAlias [-CommandAst] <CommandAst> [<CommonParameters>]
```

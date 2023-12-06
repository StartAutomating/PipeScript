NamespacedObject
----------------

### Synopsis
Namespaced functions

---

### Description

Allows the declaration of a object or singleton in a namespace.

Namespaces are used to logically group functionality and imply standardized behavior.

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    My Object Precious { $IsARing = $true; $BindsThemAll = $true }
    My.Precious
}
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
NamespacedObject [-CommandAst] <CommandAst> [<CommonParameters>]
```

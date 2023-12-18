ModuleRelationship
------------------

### Synopsis
Gets Module Relationships

---

### Description

Gets Modules that are related to a given module.

Modules can be related to each other by a few mechanisms:

* A Module Can Include another Module's Name in it's ```.PrivateData.PSData.Tags```
* A Module Can include data for another module it it's ```.PrivataData.```

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $Module = Get-Module PipeScript
    [ModuleRelationships()]$Module
}
```

---

### Parameters
#### **VariableAST**
A VariableExpression.  This variable must contain a module or name of module.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ModuleRelationship -VariableAST <VariableExpressionAst> [<CommonParameters>]
```

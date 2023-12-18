Aspect.GroupObjectByType
------------------------

### Synopsis
Groups objects by types

---

### Description

Groups objects by objects by their .NET type

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ChildItem | Aspect.GroupByType
```

---

### Parameters
#### **InputObject**
One or More Input Objects

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|false   |1       |true (ByValue)|

---

### Syntax
```PowerShell
Aspect.GroupObjectByType [[-InputObject] <PSObject[]>] [<CommonParameters>]
```

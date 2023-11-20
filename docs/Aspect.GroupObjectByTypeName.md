Aspect.GroupObjectByTypeName
----------------------------

### Synopsis
Groups objects by type name

---

### Description

Groups objects by the first of their `.pstypenames`

---

### Examples
> EXAMPLE 1

```PowerShell
Get-ChildItem | Aspect.GroupByTypeName
```

---

### Parameters
#### **InputObject**
One or More InputObjects

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|false   |1       |true (ByValue)|

---

### Syntax
```PowerShell
Aspect.GroupObjectByTypeName [[-InputObject] <PSObject[]>] [<CommonParameters>]
```

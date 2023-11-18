Aspect.ModuleExtensionType
--------------------------

### Synopsis
Outputs a module's extension types

---

### Description

Outputs the extension types defined in a module's manifest.

---

### Examples
Outputs a PSObject with information about extension command types.
The two primary pieces of information are the `.Name` and `.Pattern`.

```PowerShell
Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
```

---

### Parameters
#### **Module**
The name of a module, or a module info object.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|true    |1       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Aspect.ModuleExtensionType [-Module] <Object> [<CommonParameters>]
```

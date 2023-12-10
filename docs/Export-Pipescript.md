Export-Pipescript
-----------------

### Synopsis
Builds and Exports using PipeScript

---

### Description

Builds and Exports a path, using PipeScript.

Any Source Generator Files Discovered by PipeScript will be run, which will convert them into source code.

---

### Examples
> EXAMPLE 1

```PowerShell
Export-PipeScript
```

---

### Parameters
#### **InputPath**
One or more input paths.  If no -InputPath is provided, will build all scripts beneath the current directory.

|Type        |Required|Position|PipelineInput        |Aliases |
|------------|--------|--------|---------------------|--------|
|`[String[]]`|false   |1       |true (ByPropertyName)|FullName|

#### **Serial**
If set, will prefer to build in a series, rather than in parallel.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Export-Pipescript [[-InputPath] <String[]>] [-Serial] [<CommonParameters>]
```

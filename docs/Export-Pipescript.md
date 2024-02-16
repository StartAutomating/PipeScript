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
Export-PipeScript -Serial   # (PipeScript builds in parallel by default)
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

#### **Parallel**
If set, will build in parallel

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **BatchSize**
The number of files to build in each batch.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |2       |false        |

#### **ThrottleLimit**
The throttle limit for parallel jobs.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |3       |false        |

---

### Syntax
```PowerShell
Export-Pipescript [[-InputPath] <String[]>] [-Serial] [-Parallel] [[-BatchSize] <Int32>] [[-ThrottleLimit] <Int32>] [<CommonParameters>]
```

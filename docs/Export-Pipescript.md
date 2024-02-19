Export-Pipescript
-----------------

### Synopsis
Export PipeScript

---

### Description

Builds a path with PipeScript, which exports the outputted files.

Build Scripts (`*.build.ps1`) will run,
then all Template Files (`*.ps.*` or `*.ps1.*`) will build.

Either file can contain a `[ValidatePattern]` or `[ValidateScript]` to make the build conditional.

The condition will be validated against the last git commit (if present).

---

### Examples
> EXAMPLE 1

```PowerShell
Export-PipeScript # (PipeScript can build in parallel)
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

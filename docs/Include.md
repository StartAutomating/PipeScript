Include
-------

### Synopsis
Includes Files

---

### Description

Includes Files or Functions into a Script.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    [Include("Invoke-PipeScript")]$null
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
{
    [Include("Invoke-PipeScript")]
    param()
} | .>PipeScript
```
> EXAMPLE 3

```PowerShell
{
    [Include('*-*.ps1')]$psScriptRoot
} | .>PipeScript
```
> EXAMPLE 4

```PowerShell
{
    [Include('https://pssvg.start-automating.com/Examples/PowerShellChevron.svg')]$PSChevron
} | .>PipeScript
```

---

### Parameters
#### **FilePath**
The File Path to Include

|Type      |Required|Position|PipelineInput|Aliases                 |
|----------|--------|--------|-------------|------------------------|
|`[String]`|false   |1       |false        |FullName<br/>Uri<br/>Url|

#### **AsByte**
If set, will include the content as a byte array

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Passthru**
If set, will pass thru the included item

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Exclude**
The exclusion pattern to use.

|Type        |Required|Position|PipelineInput|Aliases       |
|------------|--------|--------|-------------|--------------|
|`[String[]]`|false   |named   |false        |ExcludePattern|

#### **VariableAst**
The variable that include will be applied to.
If including files with wildcards, this will be the base path.
Otherwise, this variable will be assigned to the included value.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

#### **CommandAst**
The CommandAST.
This is provided by the transpiler when include is used as a keyword.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
Include [[-FilePath] <String>] [-AsByte] [-Passthru] [-Exclude <String[]>] -CommandAst <CommandAst> [<CommonParameters>]
```
```PowerShell
Include [-FilePath] <String> [-AsByte] [-Passthru] [-Exclude <String[]>] -VariableAst <VariableExpressionAst> [<CommonParameters>]
```

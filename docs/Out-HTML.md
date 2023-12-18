Out-HTML
--------

### Synopsis
Produces HTML output from the PowerShell pipeline.

---

### Description

Produces HTML output from the PowerShell pipeline, doing the best possible to obey the formatting rules in PowerShell.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Process -id $pid | Out-HTML
```

---

### Parameters
#### **InputObject**
The input object

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |1       |true (ByValue)|

#### **Id**
The desired identifier for the output.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **CssClass**
The CSS class for the output.  This will be inferred from the .pstypenames

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

#### **Style**
A CSS Style

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |4       |false        |

#### **ItemType**
If set, will enclose the output in a div with an itemscope and itemtype attribute

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |5       |true (ByPropertyName)|

#### **ViewName**
If more than one view is available, this view will be used

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |6       |false        |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
Out-HTML [[-InputObject] <PSObject>] [[-Id] <String>] [[-CssClass] <String>] [[-Style] <IDictionary>] [[-ItemType] <String[]>] [[-ViewName] <String>] [<CommonParameters>]
```

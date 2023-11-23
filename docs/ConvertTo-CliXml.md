ConvertTo-CliXml
----------------

### Synopsis
Converts PowerShell objects into CliXML

---

### Description

Converts PowerShell objects into CliXML strings or compressed CliXML strings

---

### Related Links
* [ConvertFrom-Clixml](ConvertFrom-Clixml.md)

* [Import-Clixml](https://learn.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Import-Clixml)

* [Export-Clixml](https://learn.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Export-Clixml)

---

### Examples
> EXAMPLE 1

```PowerShell
dir | ConvertTo-Clixml
```

---

### Parameters
#### **InputObject**
The input object

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|true    |1       |true (ByValue)|

#### **Depth**
The depth of objects to serialize.
By default, this will be the $FormatEnumerationLimit.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
ConvertTo-CliXml [-InputObject] <PSObject[]> [-Depth <Int32>] [<CommonParameters>]
```

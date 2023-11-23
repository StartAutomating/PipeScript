ConvertFrom-CliXml
------------------

### Synopsis
Converts CliXml into PowerShell objects

---

### Description

Converts CliXml strings or compressed CliXml strings into PowerShell objects

---

### Related Links
* [ConvertTo-Clixml](ConvertTo-Clixml.md)

* [Import-Clixml](https://learn.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Import-Clixml)

* [Export-Clixml](https://learn.microsoft.com/powershell/module/Microsoft.PowerShell.Utility/Export-Clixml)

---

### Examples
> EXAMPLE 1

```PowerShell
dir | ConvertTo-Clixml | ConvertFrom-Clixml
```

---

### Parameters
#### **InputObject**
The input object.
This is expected to be a CliXML string or XML object

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|true    |2       |true (ByValue)|

---

### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)

---

### Syntax
```PowerShell
ConvertFrom-CliXml [-InputObject] <PSObject> [<CommonParameters>]
```

Template.Import.py
------------------

### Synopsis
Python Import Template

---

### Description

Template for Import statements in Python

---

### Examples
> EXAMPLE 1

```PowerShell
Template.Import.py -ModuleName sys
```
> EXAMPLE 2

```PowerShell
'sys','json' | Template.Import.py -As { $_[0] }
```

---

### Parameters
#### **ModuleName**
The name of one or more libraries to import.

|Type        |Required|Position|PipelineInput                 |Aliases                    |
|------------|--------|--------|------------------------------|---------------------------|
|`[String[]]`|false   |1       |true (ByValue, ByPropertyName)|LibraryName<br/>PackageName|

#### **Function**
The name of one or more functions to import from the module

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |2       |true (ByPropertyName)|From   |

#### **As**
The alias for the imported type or function.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |3       |true (ByPropertyName)|Alias  |

---

### Syntax
```PowerShell
Template.Import.py [[-ModuleName] <String[]>] [[-Function] <String>] [[-As] <String>] [<CommonParameters>]
```

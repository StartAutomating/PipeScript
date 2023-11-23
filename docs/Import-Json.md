Import-Json
-----------

### Synopsis
Imports json

---

### Description

Imports json files and outputs PowerShell objects

---

### Parameters
#### **Delimiter**
The delimiter between objects.    
If a delimiter is provided, the content will be split by this delimeter.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Path**
Specifies the path to the XML files.

|Type        |Required|Position|PipelineInput                 |
|------------|--------|--------|------------------------------|
|`[String[]]`|true    |1       |true (ByValue, ByPropertyName)|

#### **LiteralPath**
Specifies the path to the XML files.    
Unlike Path , the value of the LiteralPath parameter is used exactly as it's typed.    
No characters are interpreted as wildcards.    
If the path includes escape characters, enclose it in single quotation marks.    
Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

|Type        |Required|Position|PipelineInput        |Aliases      |
|------------|--------|--------|---------------------|-------------|
|`[String[]]`|true    |named   |true (ByPropertyName)|PSPath<br/>LP|

#### **IncludeTotalCount**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Skip**
Ignores the specified number of objects and then gets the remaining objects. Enter the number of objects to skip.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt64]`|false   |named   |false        |

#### **First**
Gets only the specified number of objects. Enter the number of objects to get.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt64]`|false   |named   |false        |

---

### Syntax
```PowerShell
Import-Json [-Delimiter <String>] [-Path] <String[]> [-IncludeTotalCount] [-Skip <UInt64>] [-First <UInt64>] [<CommonParameters>]
```
```PowerShell
Import-Json [-Delimiter <String>] -LiteralPath <String[]> [-IncludeTotalCount] [-Skip <UInt64>] [-First <UInt64>] [<CommonParameters>]
```

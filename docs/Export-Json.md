Export-Json
-----------

### Synopsis
Exports content as JSON

---

### Description

Exports content as JSON

---

### Examples
> EXAMPLE 1

```PowerShell
1..10 | Export-Json -Path .\Test.json
```

---

### Parameters
#### **Delimiter**
The delimiter between objects.    
If a delimiter is provided, it will be placed between each JSON object.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Depth**

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |

#### **Path**
Specifies the path to the file where the JSON representation of the object will be stored.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |

#### **LiteralPath**
Specifies the path to the file where the JSON representation of the object will be stored.    
Unlike Path, the value of the LiteralPath parameter is used exactly as it's typed.    
No characters are interpreted as wildcards.    
If the path includes escape characters, enclose it in single quotation marks.    
Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

|Type      |Required|Position|PipelineInput|Aliases      |
|----------|--------|--------|-------------|-------------|
|`[String]`|true    |named   |false        |PSPath<br/>LP|

#### **InputObject**
Specifies the object to be converted.    
Enter a variable that contains the objects, or type a command or expression that gets the objects.    
You can also pipe objects to `Export-Json`.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|true    |named   |true (ByValue)|

#### **Force**
Forces the command to run without asking for user confirmation.    
Causes the cmdlet to clear the read-only attribute of the output file if necessary.    
The cmdlet will attempt to reset the read-only attribute when the command completes.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **NoClobber**
Indicates that the cmdlet doesn't overwrite the contents of an existing file.    
By default, if a file exists in the specified path, `Export-Clixml` overwrites the file without warning.

|Type      |Required|Position|PipelineInput|Aliases    |
|----------|--------|--------|-------------|-----------|
|`[Switch]`|false   |named   |false        |NoOverwrite|

#### **Encoding**
Specifies the type of encoding for the target file. The default value is `utf8NoBOM`.    
The acceptable values for this parameter are as follows:    
* `ascii`: Uses the encoding for the ASCII (7-bit) character set.    
* `bigendianunicode`: Encodes in UTF-16 format using the big-endian byte order.    
* `bigendianutf32`: Encodes in UTF-32 format using the big-endian byte order.    
* `oem`: Uses the default encoding for MS-DOS and console programs.    
* `unicode`: Encodes in UTF-16 format using the little-endian byte order.    
* `utf7`: Encodes in UTF-7 format.    
* `utf8`: Encodes in UTF-8 format.    
* `utf8BOM`: Encodes in UTF-8 format with Byte Order Mark (BOM)    
* `utf8NoBOM`: Encodes in UTF-8 format without Byte Order Mark (BOM)    
* `utf32`: Encodes in UTF-32 format.    
Beginning with PowerShell 6.2, the Encoding parameter also allows numeric IDs of registered code pages (like `-Encoding 1251`) or string names of registered code pages (like `-Encoding "windows-1251"`). For more information, see the .NET documentation for Encoding.CodePage (/dotnet/api/system.text.encoding.codepage?view=netcore-2.2).    
> [!NOTE] > UTF-7 * is no longer recommended to use. As of PowerShell 7.1, a warning is written if you > specify `utf7` for the Encoding parameter.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[Encoding]`|false   |named   |false        |

#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.

If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---

### Syntax
```PowerShell
Export-Json [-Delimiter <String>] [-Depth <Int32>] [-Path] <String> -InputObject <PSObject> [-Force] [-NoClobber] [-Encoding <Encoding>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Export-Json [-Delimiter <String>] [-Depth <Int32>] -LiteralPath <String> -InputObject <PSObject> [-Force] [-NoClobber] [-Encoding <Encoding>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

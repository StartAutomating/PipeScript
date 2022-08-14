
Inline.TOML
-----------
### Synopsis
TOML Inline PipeScript Transpiler.

---
### Description

Transpiles TOML with Inline PipeScript into TOML.

Because TOML does not support comment blocks, PipeScript can be written inline inside of specialized Multiline string

PipeScript can be included in a TOML string that starts and ends with ```{}```, for example ```"""{}"""```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $tomlContent = @'
[seed]
RandomNumber = """{Get-Random}"""
'@
    [OutputFile('.\RandomExample.ps1.toml')]$tomlContent
}
```
.> .\RandomExample.ps1.toml
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[CommandInfo]```|true    |1      |true (ByValue)|
---
#### **Parameter**

A dictionary of parameters.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |2      |false        |
---
#### **ArgumentList**

A list of arguments.



|Type              |Requried|Postion|PipelineInput|
|------------------|--------|-------|-------------|
|```[PSObject[]]```|false   |3      |false        |
---
### Syntax
```PowerShell
Inline.TOML [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



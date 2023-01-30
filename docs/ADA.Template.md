ADA.Template
------------
### Synopsis
ADA Template Transpiler.

---
### Description

Allows PipeScript to be used to generate ADA.

Because ADA Scripts only allow single-line comments, this is done using a pair of comment markers.

-- { or -- PipeScript{  begins a PipeScript block

-- } or -- }PipeScript  ends a PipeScript block

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $AdaScript = '    
with Ada.Text_IO;
```
procedure Hello_World is
begin
    -- {

    Uncommented lines between these two points will be ignored

    --  # Commented lines will become PipeScript / PowerShell.
    -- param($message = "hello world")        
    -- "Ada.Text_IO.Put_Line (`"$message`");"
    -- }
end Hello_World;    
'

    [OutputFile('.\HelloWorld.ps1.adb')]$AdaScript
}

Invoke-PipeScript .\HelloWorld.ps1.adb
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |



---
#### **Parameter**

A dictionary of parameters.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



---
#### **ArgumentList**

A list of arguments.






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |



---
### Syntax
```PowerShell
ADA.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
ADA.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---


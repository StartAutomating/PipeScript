
Inline.ADA
----------
### Synopsis
ADA PipeScript Transpiler.

---
### Description

Transpiles ADA with Inline PipeScript into ADA.

Because ADA Scripts only allow single-line comments, this is done using a pair of comment markers.

-- { or -- PipeScript{  begins a PipeScript block

-- } or -- }PipeScript  ends a PipeScript block

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $AdaScript = &#39;    
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



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.ADA [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




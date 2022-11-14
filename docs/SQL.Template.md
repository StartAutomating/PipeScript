SQL.Template
------------
### Synopsis
SQL Template Transpiler.

---
### Description

Allows PipeScript to generate SQL.

Because SQL Scripts only allow single-line comments, this is done using a pair of comment markers.
   
-- { or -- PipeScript{  begins a PipeScript block

-- } or -- }PipeScript  ends a PipeScript block

```SQL    
-- {

Uncommented lines between these two points will be ignored

--  # Commented lines will become PipeScript / PowerShell.
-- param($message = 'hello world')
-- "-- $message"
-- }
```

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $SQLScript = '    
-- {
```
Uncommented lines between these two points will be ignored

--  # Commented lines will become PipeScript / PowerShell.
-- param($message = "hello world")
-- "-- $message"
-- }
'

    [OutputFile('.\HelloWorld.ps1.sql')]$SQLScript
}

Invoke-PipeScript .\HelloWorld.ps1.sql
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
SQL.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
SQL.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---


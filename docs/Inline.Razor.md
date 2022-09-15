
Inline.Razor
------------
### Synopsis
Razor Inline PipeScript Transpiler.

---
### Description

Transpiles Razor with Inline PipeScript into Razor.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.

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
Inline.Razor [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




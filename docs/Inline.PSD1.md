
Inline.PSD1
-----------
### Synopsis
PSD1 Inline PipeScript Transpiler.

---
### Description

Transpiles PSD1 with Inline PipeScript into PSD1.

Multiline comments blocks enclosed with {} will be treated as Blocks of PipeScript.

Multiline comments can be preceeded or followed by single-quoted strings, which will be ignored.

* ```''```
* ```{}```

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
Inline.PSD1 [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---





Inline.ObjectiveC
-----------------
### Synopsis
Objective C PipeScript Transpiler.

---
### Description

Transpiles Objective C/C++ with Inline PipeScript into Objective C/C++.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid C/C++ syntax. 

The Objective C Inline Transpiler will consider the following syntax to be empty:

* ```null```
* ```nil```
* ```""```
* ```''```

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
Inline.ObjectiveC [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




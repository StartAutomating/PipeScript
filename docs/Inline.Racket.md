Inline.Racket
-------------
### Synopsis
Racket Inline PipeScript Transpiler.

---
### Description

Transpiles Racket with Inline PipeScript into Racket.

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
Inline.Racket [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


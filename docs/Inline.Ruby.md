Inline.Ruby
-----------
### Synopsis
Ruby Inline PipeScript Transpiler.

---
### Description

Transpiles Ruby with Inline PipeScript into Ruby.

PipeScript can be embedded in a multiline block that starts with ```=begin{``` and ends with } (followed by ```=end```)

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
Inline.Ruby [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


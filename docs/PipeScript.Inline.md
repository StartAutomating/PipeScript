PipeScript.Inline
-----------------
### Synopsis
Inline Transpiler

---
### Description

The PipeScript Core Inline Transpiler.  This makes Source Generators with inline PipeScript work.

Regardless of underlying source language, a source generator works in a fairly straightforward way.

Inline PipeScript will be embedded within the file (usually in comments).

If a Regular Expression can match each section, then the content in each section can be replaced.

---
### Parameters
#### **SourceText**

A string containing the text contents of the file



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **ReplacePattern**

> **Type**: ```[Regex]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **StartPattern**

The Start Pattern.
This indicates the beginning of what should be considered PipeScript.
An expression will match everything until -EndPattern



> **Type**: ```[Regex]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **EndPattern**

The End Pattern
This indicates the end of what should be considered PipeScript.



> **Type**: ```[Regex]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **ReplacementEvaluator**

A custom replacement evaluator.
If not provided, will run any embedded scripts encountered. 
The output of these scripts will be the replacement text.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **NoTranspile**

If set, will not transpile script blocks.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **SourceFile**

The path to the source file.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
#### **Begin**

A Script Block that will be injected before each inline is run.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
#### **ForeachObject**

A Script Block that will be piped to after each output.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:false



---
#### **End**

A Script Block that will be injected after each inline script is run.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:false



---
#### **Parameter**

A collection of parameters



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:false



---
#### **ArgumentList**

An argument list.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:false



---
#### **LinePattern**

Some languages only allow single-line comments.
To work with these languages, provide a -LinePattern indicating what makes a comment
Only lines beginning with this pattern within -StartPattern and -EndPattern will be considered a script.



> **Type**: ```[Regex]```

> **Required**: false

> **Position**: 12

> **PipelineInput**:false



---
### Syntax
```PowerShell
PipeScript.Inline [-SourceText] <String> [[-ReplacePattern] <Regex>] [[-StartPattern] <Regex>] [[-EndPattern] <Regex>] [[-ReplacementEvaluator] <ScriptBlock>] [-NoTranspile] [[-SourceFile] <String>] [[-Begin] <ScriptBlock>] [[-ForeachObject] <ScriptBlock>] [[-End] <ScriptBlock>] [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [[-LinePattern] <Regex>] [<CommonParameters>]
```
---


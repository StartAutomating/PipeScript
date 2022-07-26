
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



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|true    |1      |false        |
---
#### **ReplacePattern**

|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Regex]```|false   |2      |false        |
---
#### **StartPattern**

The Start Pattern.
This indicates the beginning of what should be considered PipeScript.
An expression will match everything until -EndPattern



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Regex]```|false   |3      |false        |
---
#### **EndPattern**

The End Pattern
This indicates the end of what should be considered PipeScript.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Regex]```|false   |4      |false        |
---
#### **ReplacementEvaluator**

A custom replacement evaluator.
If not provided, will run any embedded scripts encountered. 
The output of these scripts will be the replacement text.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[ScriptBlock]```|false   |5      |false        |
---
#### **NoTranspile**

If set, will not transpile script blocks.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **SourceFile**

The path to the source file.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |6      |false        |
---
#### **Begin**

A Script Block that will be injected before each inline is run.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[ScriptBlock]```|false   |7      |false        |
---
#### **ForeachObject**

A Script Block that will be piped to after each output.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[ScriptBlock]```|false   |8      |false        |
---
#### **End**

A Script Block that will be injected after each inline script is run.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[ScriptBlock]```|false   |9      |false        |
---
#### **Parameter**

A collection of parameters



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |10     |false        |
---
#### **ArgumentList**

An argument list.



|Type              |Requried|Postion|PipelineInput|
|------------------|--------|-------|-------------|
|```[PSObject[]]```|false   |11     |false        |
---
### Syntax
```PowerShell
PipeScript.Inline [-SourceText] <String> [[-ReplacePattern] <Regex>] [[-StartPattern] <Regex>] [[-EndPattern] <Regex>] [[-ReplacementEvaluator] <ScriptBlock>] [-NoTranspile] [[-SourceFile] <String>] [[-Begin] <ScriptBlock>] [[-ForeachObject] <ScriptBlock>] [[-End] <ScriptBlock>] [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



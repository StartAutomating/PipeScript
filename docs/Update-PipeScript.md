
Update-PipeScript
-----------------
### Synopsis
Updates PowerShell and PipeScript ScriptBlocks

---
### Description

Updates ScriptBlocks written in PowerShell or PipeScript.  Also updates blocks of text.

Update-PipeScript is used by PipeScript transpilers in order to make a number of changes to a script.

It can also be used interactively to transform scripts or text in a number of ways.

---
### Parameters
#### **ScriptBlock**

A Script Block, written in PowerShell or PipeScript.



|Type               |Requried|Postion|PipelineInput                 |
|-------------------|--------|-------|------------------------------|
|```[ScriptBlock]```|false   |1      |true (ByValue, ByPropertyName)|
---
#### **Text**

A block of text.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |2      |true (ByPropertyName)|
---
#### **TextReplacement**

Replaces sections within text.  -TextReplacement is a dictionary of replacements.
Keys in the dictionary must be a string describing a character range, in the form start,end.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |3      |false        |
---
#### **AstReplacement**

If set, will replace items based off of the abstract syntax tree.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |4      |false        |
---
#### **RegexReplacement**

If provided, will replace regular expression matches.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |5      |false        |
---
#### **RemoveParameter**

If provided, will remove one or more parameters from a ScriptBlock.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|false   |6      |false        |
---
#### **RenameVariable**

A collection of variables to rename.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |7      |false        |
---
#### **Transpile**

If set, will transpile the updated script block.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
### Syntax
```PowerShell
Update-PipeScript [[-ScriptBlock] <ScriptBlock>] [[-Text] <String>] [[-TextReplacement] <IDictionary>] [[-AstReplacement] <IDictionary>] [[-RegexReplacement] <IDictionary>] [[-RemoveParameter] <String[]>] [[-RenameVariable] <IDictionary>] [-Transpile] [<CommonParameters>]
```
---



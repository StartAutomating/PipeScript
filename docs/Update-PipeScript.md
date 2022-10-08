
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
### Examples
#### EXAMPLE 1
```PowerShell
Update-PipeScript -ScriptBlock {
    param($x,$y)
} -RemoveParameter x
```

#### EXAMPLE 2
```PowerShell
Update-PipeScript -RenameVariable @{x='y'} -ScriptBlock {$x}
```

#### EXAMPLE 3
```PowerShell
Update-PipeScript -ScriptBlock {
    #region MyRegion
    1
    #endregion MyRegion
    2
} -RegionReplacement @{MyRegion=''}
```

---
### Parameters
#### **ScriptBlock**

A Script Block, written in PowerShell or PipeScript.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByValue, ByPropertyName)



---
#### **Text**

A block of text.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **TextReplacement**

Replaces sections within text.  -TextReplacement is a dictionary of replacements.
Keys in the dictionary must be a string describing a character range, in the form start,end.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
#### **AstReplacement**

If set, will replace items based off of the abstract syntax tree.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **RegexReplacement**

If provided, will replace regular expression matches.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **RegionReplacement**

If provided, will replace regions.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:false



---
#### **RemoveParameter**

If provided, will remove one or more parameters from a ScriptBlock.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
#### **RenameVariable**

A collection of variables to rename.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:false



---
#### **Transpile**

If set, will transpile the updated script block.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Update-PipeScript [[-ScriptBlock] <ScriptBlock>] [[-Text] <String>] [[-TextReplacement] <IDictionary>] [[-AstReplacement] <IDictionary>] [[-RegexReplacement] <IDictionary>] [[-RegionReplacement] <IDictionary>] [[-RemoveParameter] <String[]>] [[-RenameVariable] <IDictionary>] [-Transpile] [<CommonParameters>]
```
---



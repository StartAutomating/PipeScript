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






|Type           |Required|Position|PipelineInput                 |Aliases   |
|---------------|--------|--------|------------------------------|----------|
|`[ScriptBlock]`|false   |1       |true (ByValue, ByPropertyName)|Definition|



#### **Text**

A block of text.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



#### **TextReplacement**

Replaces sections within text.  -TextReplacement is a dictionary of replacements.
Keys in the dictionary must be a string describing a character range, in the form start,end.






|Type           |Required|Position|PipelineInput|Aliases                                                                      |
|---------------|--------|--------|-------------|-----------------------------------------------------------------------------|
|`[IDictionary]`|false   |3       |false        |ScriptReplacements<br/>TextReplacements<br/>ScriptReplacement<br/>ReplaceText|



#### **AstReplacement**

If set, will replace items based off of the abstract syntax tree.






|Type           |Required|Position|PipelineInput|Aliases                       |
|---------------|--------|--------|-------------|------------------------------|
|`[IDictionary]`|false   |4       |false        |AstReplacements<br/>ReplaceAST|



#### **RegexReplacement**

If provided, will replace regular expression matches.






|Type           |Required|Position|PipelineInput|Aliases                           |
|---------------|--------|--------|-------------|----------------------------------|
|`[IDictionary]`|false   |5       |false        |ReplaceRegex<br/>RegexReplacements|



#### **RegionReplacement**

If provided, will replace regions.






|Type           |Required|Position|PipelineInput|Aliases      |
|---------------|--------|--------|-------------|-------------|
|`[IDictionary]`|false   |6       |false        |ReplaceRegion|



#### **RemoveParameter**

If provided, will remove one or more parameters from a ScriptBlock.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |7       |false        |



#### **InsertBefore**

If provided, will insert text before any regular epxression match.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |8       |false        |



#### **InsertAfter**

If provided, will insert text after any regular expression match.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |9       |false        |



#### **RenameVariable**

A collection of variables to rename.






|Type           |Required|Position|PipelineInput|Aliases        |
|---------------|--------|--------|-------------|---------------|
|`[IDictionary]`|false   |10      |false        |RenameParameter|



#### **Transpile**

If set, will transpile the updated script block.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Update-PipeScript [[-ScriptBlock] <ScriptBlock>] [[-Text] <String>] [[-TextReplacement] <IDictionary>] [[-AstReplacement] <IDictionary>] [[-RegexReplacement] <IDictionary>] [[-RegionReplacement] <IDictionary>] [[-RemoveParameter] <String[]>] [[-InsertBefore] <IDictionary>] [[-InsertAfter] <IDictionary>] [[-RenameVariable] <IDictionary>] [-Transpile] [<CommonParameters>]
```

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
> EXAMPLE 1

```PowerShell
Update-PipeScript -ScriptBlock {
    param($x,$y)
} -RemoveParameter x
```
> EXAMPLE 2

```PowerShell
Update-PipeScript -RenameVariable @{x='y'} -ScriptBlock {$x}
```
> EXAMPLE 3

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

#### **AstCondition**

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |5       |false        |

#### **RegexReplacement**
If provided, will replace regular expression matches.

|Type           |Required|Position|PipelineInput|Aliases                           |
|---------------|--------|--------|-------------|----------------------------------|
|`[IDictionary]`|false   |6       |false        |ReplaceRegex<br/>RegexReplacements|

#### **RegionReplacement**
If provided, will replace regions.

|Type           |Required|Position|PipelineInput|Aliases      |
|---------------|--------|--------|-------------|-------------|
|`[IDictionary]`|false   |7       |false        |ReplaceRegion|

#### **RemoveParameter**
If provided, will remove one or more parameters from a ScriptBlock.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |8       |false        |

#### **InsertBefore**
If provided, will insert text before any regular epxression match.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |9       |false        |

#### **InsertAfter**
If provided, will insert text after any regular expression match.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |10      |false        |

#### **InsertAfterAST**
A dictionary of items to insert after an AST element.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |11      |false        |

#### **InsertBeforeAst**
A dictionary of items to insert before an AST element.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |12      |false        |

#### **InsertBlockStart**
A dictionary of items to insert at the start of another item's AST block.
The key should be an AST element.
The nearest block start will be the point that the item is inserted.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |13      |false        |

#### **InsertBlockEnd**
A dictionary of items to insert at the start of another item's AST block.
The key should be an AST element.
The nearest block end will be the point that the item is inserted.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |14      |false        |

#### **TextInsertion**
A dictionary of text insertions.
The key is the insertion index.
The value is the insertion.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |15      |false        |

#### **RegexInsertion**
A dictionary of regex based insertions
This works similarly to -RegexReplacement.

|Type           |Required|Position|PipelineInput|Aliases        |
|---------------|--------|--------|-------------|---------------|
|`[IDictionary]`|false   |16      |false        |RegexInsertions|

#### **RenameVariable**
A collection of variables to rename.

|Type           |Required|Position|PipelineInput|Aliases        |
|---------------|--------|--------|-------------|---------------|
|`[IDictionary]`|false   |17      |false        |RenameParameter|

#### **Append**
Content to append.
Appended ScriptBlocks will be added to the last block of a ScriptBlock.
Appended Text will be added to the end.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |18      |false        |

#### **Prepend**
Content to prepend
Prepended ScriptBlocks will be added to the first block of a ScriptBlock.
Prepended text will be added at the start.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |19      |false        |

#### **Transpile**
If set, will transpile the updated script block.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Update-PipeScript [[-ScriptBlock] <ScriptBlock>] [[-Text] <String>] [[-TextReplacement] <IDictionary>] [[-AstReplacement] <IDictionary>] [[-AstCondition] <IDictionary>] [[-RegexReplacement] <IDictionary>] [[-RegionReplacement] <IDictionary>] [[-RemoveParameter] <String[]>] [[-InsertBefore] <IDictionary>] [[-InsertAfter] <IDictionary>] [[-InsertAfterAST] <IDictionary>] [[-InsertBeforeAst] <IDictionary>] [[-InsertBlockStart] <IDictionary>] [[-InsertBlockEnd] <IDictionary>] [[-TextInsertion] <IDictionary>] [[-RegexInsertion] <IDictionary>] [[-RenameVariable] <IDictionary>] [[-Append] <Object>] [[-Prepend] <Object>] [-Transpile] [<CommonParameters>]
```

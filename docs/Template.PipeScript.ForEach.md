Template.PipeScript.ForEach
---------------------------

### Synopsis
Template for a PipeScript `foreach` Loop

---

### Description

Template for a `foreach` loop in PipeScript (which is really just a foreach loop in PowerShell)

---

### Parameters
#### **Variable**
The For Loop's Initialization.
This initializes the loop.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Condition**
The For Loop's Condition.
This determine if the loop should continue running.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **ForEachKeyword**
The language keyword that represents a `foreach` loop.  This is usually `foreach`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **ForEachInKeyword**
The language keyword that separates a variable and condition.  This is usually `in`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

#### **SubExpressionStart**
The sub expression start sequence. This is usually `(`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **SubExpressionEnd**
The sub expression end sequence. This is usually `)`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **BlockStart**
The start of a block.  This is usually `{`

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |8       |false        |

#### **BlockEnd**
The end of a block.  This is usually `}`

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |9       |false        |

---

### Notes
If provided a PowerShell foreach loop's AST as pipeline input, this should produce the same script.

---

### Syntax
```PowerShell
Template.PipeScript.ForEach [[-Variable] <String>] [[-Condition] <String>] [[-Body] <String>] [[-ForEachKeyword] <String>] [[-ForEachInKeyword] <String>] [[-SubExpressionStart] <String>] [[-SubExpressionEnd] <String>] [[-BlockStart] <String>] [[-BlockEnd] <String>] [<CommonParameters>]
```

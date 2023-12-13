Template.PipeScript.For
-----------------------

### Synopsis
Template for a PipeScript `for` Loop

---

### Description

Template for a `for` loop in PipeScript (which is just a for loop in PowerShell)

---

### Parameters
#### **Initialization**
The For Loop's Initialization.
This initializes the loop.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[String]`|false   |1       |true (ByPropertyName)|Initializer|

#### **Condition**
The For Loop's Condition.
This determine if the loop should continue running.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Afterthought**
The For Loop's Iterator, or Afterthought.
This occurs after each iteration of the loop

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |3       |true (ByPropertyName)|Iterator|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **ForKeyword**
The language keyword that represents a `for` loop.  This is usually `for`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

#### **ForSeparator**
The separator between each clause in the `for` loop.  This is usually `;`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **SubExpressionStart**
The sub expression start sequence. This is usually `(`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **SubExpressionEnd**
The sub expression end sequence. This is usually `)`.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |8       |true (ByPropertyName)|

#### **BlockStart**
The start of a block.  This is usually `{`

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |9       |false        |

#### **BlockEnd**
The end of a block.  This is usually `}`

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |10      |false        |

---

### Notes
If provided a PowerShell for loop's AST as pipeline input, this should produce the same script.

---

### Syntax
```PowerShell
Template.PipeScript.For [[-Initialization] <String>] [[-Condition] <String>] [[-Afterthought] <String>] [[-Body] <String>] [[-ForKeyword] <String>] [[-ForSeparator] <String>] [[-SubExpressionStart] <String>] [[-SubExpressionEnd] <String>] [[-BlockStart] <String>] [[-BlockEnd] <String>] [<CommonParameters>]
```

ValidateScriptBlock
-------------------

### Synopsis
Validates Script Blocks

---

### Description

Validates Script Blocks for a number of common scenarios.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    param(
    [ValidateScriptBlock(Safe)]
    [ScriptBlock]
    $ScriptBlock
    )
$ScriptBlock
} | .>PipeScript
```
> EXAMPLE 2

```PowerShell
{
    param(
    [ValidateScriptBlock(NoBlock,NoParameters)]
    [ScriptBlock]
    $ScriptBlock
    )
$ScriptBlock
} | .>PipeScript
```
> EXAMPLE 3

```PowerShell
{
    param(
    [ValidateScriptBlock(OnlyParameters)]
    [ScriptBlock]
    $ScriptBlock
    )
$ScriptBlock
} | .>PipeScript
```

---

### Parameters
#### **DataLanguage**
If set, will validate that ScriptBlock is "safe".
This will attempt to recreate the Script Block as a datalanguage block and execute it.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Safe   |

#### **ParameterOnly**
If set, will ensure that the [ScriptBlock] only has parameters

|Type      |Required|Position|PipelineInput|Aliases       |
|----------|--------|--------|-------------|--------------|
|`[Switch]`|false   |named   |false        |OnlyParameters|

#### **NoBlock**
If set, will ensure that the [ScriptBlock] has no named blocks.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|false   |named   |false        |NoBlocks|

#### **NoParameter**
If set, will ensure that the [ScriptBlock] has no parameters.

|Type      |Required|Position|PipelineInput|Aliases                 |
|----------|--------|--------|-------------|------------------------|
|`[Switch]`|false   |named   |false        |NoParameters<br/>NoParam|

#### **IncludeCommand**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

#### **ExcludeCommand**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

#### **IncludeType**
If set, will ensure that the script block contains types in this list.
Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

#### **ExcludeType**
If set, will ensure that the script block does not use the types in this list.
Passing -IncludeType without -ExcludeType will make -ExcludeType default to *.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

#### **NoLoop**
If set, will ensure that the ScriptBlock does not contain any loops.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |NoLoops|

#### **NoWhileLoop**
If set, will ensure that the ScriptBlock does not contain any do or while loops.

|Type      |Required|Position|PipelineInput|Aliases                                |
|----------|--------|--------|-------------|---------------------------------------|
|`[Switch]`|false   |named   |false        |NoWhileLoops<br/>NoDoLoops<br/>NoDoLoop|

#### **AstCondition**
One or more AST conditions to validate.
If no results are found or the condition throws, the script block will be considered invalid.

|Type             |Required|Position|PipelineInput|Aliases                |
|-----------------|--------|--------|-------------|-----------------------|
|`[ScriptBlock[]]`|false   |named   |false        |AstConditions<br/>IfAst|

#### **VariableAST**
A VariableExpression.  If provided, the Validation attributes will apply to this variable.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [-IncludeCommand <Object>] [-ExcludeCommand <Object>] [-IncludeType <Object>] [-ExcludeType <Object>] [-NoLoop] [-NoWhileLoop] [-AstCondition <ScriptBlock[]>] [<CommonParameters>]
```
```PowerShell
ValidateScriptBlock [-DataLanguage] [-ParameterOnly] [-NoBlock] [-NoParameter] [-IncludeCommand <Object>] [-ExcludeCommand <Object>] [-IncludeType <Object>] [-ExcludeType <Object>] [-NoLoop] [-NoWhileLoop] [-AstCondition <ScriptBlock[]>] -VariableAST <VariableExpressionAst> [<CommonParameters>]
```


ValidateTypes
-------------
### Synopsis
Validates if an object is one or more types.

---
### Description

Validates if an object is one or more types.  

This allows for a single parameter to handle multiple potential types.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    param(
    [ValidateTypes(TypeName="ScriptBlock","string")]
    $In
    )
} | .>PipeScript
```

#### EXAMPLE 2
```PowerShell
{"hello world"} |
    Invoke-PipeScript -ScriptBlock {
        param(
        [vfp()]
        [ValidateTypes(TypeName="ScriptBlock","string")]            
        $In
        )
```
$In
    }
#### EXAMPLE 3
```PowerShell
1 | 
    Invoke-PipeScript -ScriptBlock {
        param(
        [vfp()]
        [ValidateTypes(TypeName="ScriptBlock","string")]            
        $In
        )
```
$In
    }
---
### Parameters
#### **TypeName**

The name of one or more types.
Types can either be a .NET types of .PSTypenames
TypeNames will be treated first as real types, then as exact matches, then as wildcards, and then as regular expressions.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|true    |1      |false        |
---
#### **VariableAST**

The variable that will be validated.



|Type                         |Requried|Postion|PipelineInput |
|-----------------------------|--------|-------|--------------|
|```[VariableExpressionAst]```|false   |named  |true (ByValue)|
---
### Syntax
```PowerShell
ValidateTypes [-TypeName] <String[]> [<CommonParameters>]
```
```PowerShell
ValidateTypes [-TypeName] <String[]> [-VariableAST <VariableExpressionAst>] [<CommonParameters>]
```
---



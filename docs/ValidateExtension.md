
ValidateExtension
-----------------
### Synopsis
Validates Extensions

---
### Description

Validates that a parameter or object has one or more extensions.

This creates a [ValidatePattern] that will ensure the extension matches.

---
### Examples
#### EXAMPLE 1
```PowerShell
{        
    param(
    [ValidateExtension(Extension=".cs", ".ps1")]
    $FilePath
    )
} |.>PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    param(
    [ValidateExtension(Extension=".cs", ".ps1")]
    $FilePath
    )
```
$FilePath
} -Parameter @{FilePath=".ps1"}
#### EXAMPLE 3
```PowerShell
{
    param(
    [ValidateExtension(Extension=".cs", ".ps1")]
    $FilePath
    )
```
$FilePath
} -Parameter @{FilePath="foo.txt"}
---
### Parameters
#### **Extension**

The extensions being validated.



|Type            |Requried|Postion|PipelineInput|
|----------------|--------|-------|-------------|
|```[String[]]```|true    |1      |false        |
---
#### **VariableAST**

A variable expression.
If this is provided, will apply a ```[ValidatePattern({})]``` attribute to the variable, constraining future values.



|Type                         |Requried|Postion|PipelineInput |
|-----------------------------|--------|-------|--------------|
|```[VariableExpressionAst]```|false   |named  |true (ByValue)|
---
### Syntax
```PowerShell
ValidateExtension [-Extension] <String[]> [<CommonParameters>]
```
```PowerShell
ValidateExtension [-Extension] <String[]> [-VariableAST <VariableExpressionAst>] [<CommonParameters>]
```
---



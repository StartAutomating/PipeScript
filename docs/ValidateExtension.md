
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
    [ValidateExtension(Extension=&quot;.cs&quot;, &quot;.ps1&quot;)]
    $FilePath
    )
} |.&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    param(
    [ValidateExtension(Extension=&quot;.cs&quot;, &quot;.ps1&quot;)]
    $FilePath
    )
```
$FilePath
} -Parameter @{FilePath=".ps1"}
#### EXAMPLE 3
```PowerShell
{
    param(
    [ValidateExtension(Extension=&quot;.cs&quot;, &quot;.ps1&quot;)]
    $FilePath
    )
```
$FilePath
} -Parameter @{FilePath="foo.txt"}
---
### Parameters
#### **Extension**

The extensions being validated.



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **VariableAST**

A variable expression.
If this is provided, will apply a ```[ValidatePattern({})]``` attribute to the variable, constraining future values.



> **Type**: ```[VariableExpressionAst]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ValidateExtension [-Extension] &lt;String[]&gt; [&lt;CommonParameters&gt;]
```
```PowerShell
ValidateExtension [-Extension] &lt;String[]&gt; [-VariableAST &lt;VariableExpressionAst&gt;] [&lt;CommonParameters&gt;]
```
---




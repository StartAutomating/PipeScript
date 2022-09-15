
ValidatePropertyName
--------------------
### Synopsis
Validates Property Names

---
### Description

Validates that an object has one or more property names.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    param(
    [ValidatePropertyName(PropertyName=&#39;a&#39;,&#39;b&#39;)]
    $InputObject
    )
} | .&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
[PSCustomObject]@{a=&#39;a&#39;;b=&#39;b&#39;} |
    .&gt; {
        param(
        [ValidatePropertyName(PropertyName=&#39;a&#39;,&#39;b&#39;)]
        [vfp]
        $InputObject
        )
```
$InputObject
    }
#### EXAMPLE 3
```PowerShell
@{a=&#39;a&#39;} |
    .&gt; {
        param(
        [ValidatePropertyName(PropertyName=&#39;a&#39;,&#39;b&#39;)]
        [vfp]
        $InputObject
        )
```
$InputObject
    }
---
### Parameters
#### **PropertyName**

The property names being validated.



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **VariableAST**

A variable expression.
If this is provided, will apply a ```[ValidateScript({})]``` attribute to the variable, constraining future values.



> **Type**: ```[VariableExpressionAst]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ValidatePropertyName [-PropertyName] &lt;String[]&gt; [&lt;CommonParameters&gt;]
```
```PowerShell
ValidatePropertyName [-PropertyName] &lt;String[]&gt; [-VariableAST &lt;VariableExpressionAst&gt;] [&lt;CommonParameters&gt;]
```
---




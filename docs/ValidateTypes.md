
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
    [ValidateTypes(TypeName=&quot;ScriptBlock&quot;,&quot;string&quot;)]
    $In
    )
} | .&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
{&quot;hello world&quot;} |
    Invoke-PipeScript -ScriptBlock {
        param(
        [vfp()]
        [ValidateTypes(TypeName=&quot;ScriptBlock&quot;,&quot;string&quot;)]            
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
        [ValidateTypes(TypeName=&quot;ScriptBlock&quot;,&quot;string&quot;)]            
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



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **VariableAST**

The variable that will be validated.



> **Type**: ```[VariableExpressionAst]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
ValidateTypes [-TypeName] &lt;String[]&gt; [&lt;CommonParameters&gt;]
```
```PowerShell
ValidateTypes [-TypeName] &lt;String[]&gt; [-VariableAST &lt;VariableExpressionAst&gt;] [&lt;CommonParameters&gt;]
```
---




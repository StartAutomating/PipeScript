
Decorate
--------
### Synopsis
decorate transpiler

---
### Description

Applies one or more typenames to an object.
By 'decorating' the object with a typename, this enables use of the extended type system.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $v = [PSCustomObject]@{}
    [decorate(&#39;MyTypeName&#39;,Clear,PassThru)]$v
}.Transpile()
```

---
### Parameters
#### **VariableAst**

The variable decoration will be applied to.



> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **TypeName**

The TypeName(s) used to decorate the object.



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **PassThru**

If set, will output the object after it has been decorated



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Clear**

If set, will clear any underlying typenames.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Decorate -VariableAst &lt;VariableExpressionAst&gt; [-TypeName] &lt;String[]&gt; [-PassThru] [-Clear] [&lt;CommonParameters&gt;]
```
---




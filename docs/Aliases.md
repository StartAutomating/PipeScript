
Aliases
-------
### Synopsis
Dynamically Defines Aliases

---
### Description

Can Dynamically Define Aliases.

When uses in a parameter attribute, -Aliases will define a list of aliases.

When used with a variable, [Aliases] will Set-Alias on each value in the variable.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $aliases = &quot;Foo&quot;, &quot;Bar&quot;, &quot;Baz&quot;
    [Aliases(Command=&quot;Get-Process&quot;)]$aliases
} | .&gt;PipeScript
```

#### EXAMPLE 2
```PowerShell
{
    param(
    [Aliases(Aliases={
       ([char]&#39;a&#39;..[char]&#39;z&#39;)
    })]
    [string]
    $Drive
    )
} | .&gt;PipeScript
```

---
### Parameters
#### **Aliases**

A list of aliases



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Prefix**

If provided, will prefix each alias



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Suffix**

If provided, will add a suffix to each alias



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Command**

The command being aliased.  This is only required when transpiling a variable.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **PassThru**

> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **VariableAST**

A VariableExpression.  
If provided, this will be treated as the alias name or list of alias names.



> **Type**: ```[VariableExpressionAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Aliases -Aliases &lt;String[]&gt; [-Prefix &lt;String&gt;] [-Suffix &lt;String&gt;] [&lt;CommonParameters&gt;]
```
```PowerShell
Aliases [-Prefix &lt;String&gt;] [-Suffix &lt;String&gt;] -Command &lt;String&gt; [-PassThru] -VariableAST &lt;VariableExpressionAst&gt; [&lt;CommonParameters&gt;]
```
---




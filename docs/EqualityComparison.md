
EqualityComparison
------------------
### Synopsis
Allows equality comparison.

---
### Description

Allows most equality comparison using double equals (==).

Many languages support this syntax.  PowerShell does not.    

This transpiler enables equality comparison with ==.

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript -ScriptBlock {
    $a = 1    
    if ($a == 1 ) {
        &quot;A is $a&quot;
    }
}
```

#### EXAMPLE 2
```PowerShell
{
    $a == &quot;b&quot;
} | .&gt;PipeScript
```

---
### Parameters
#### **AssignmentStatementAST**

The original assignment statement.



> **Type**: ```[AssignmentStatementAst]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
EqualityComparison [-AssignmentStatementAST] &lt;AssignmentStatementAst&gt; [&lt;CommonParameters&gt;]
```
---
### Notes
This will not work if there is a constant on both sides of the expression


if ($null == $null) { "this will work"} 
if ('' == '') { "this will not"}






EqualityTypeComparison
----------------------
### Synopsis
Allows equality type comparison.

---
### Description

Allows most equality comparison using triple equals (===).

Many languages support this syntax.  PowerShell does not.    

This transpiler enables equality and type comparison with ===.

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript -ScriptBlock {
    $a = 1
    $number = 1    
    if ($a === $number ) {
        &quot;A is $a&quot;
    }
}
```

#### EXAMPLE 2
```PowerShell
Invoke-PipeScript -ScriptBlock {
    $One = 1
    $OneIsNotANumber = &quot;1&quot;
    if ($one == $OneIsNotANumber) {
        &#39;With ==, a number can be compared to a string, so $a == &quot;1&quot;&#39;
    }
    if (-not ($One === $OneIsNotANumber)) {
        &quot;With ===, a number isn&#39;t the same type as a string, so this will be false.&quot;            
    }
}
```

#### EXAMPLE 3
```PowerShell
Invoke-PipeScript -ScriptBlock {
    if ($null === $null) {
        &#39;$Null really is $null&#39;
    }
}
```

#### EXAMPLE 4
```PowerShell
Invoke-PipeScript -ScriptBlock {
    $zero = 0
    if (-not ($zero === $null)) {
        &#39;$zero is not $null&#39;
    }
}
```

#### EXAMPLE 5
```PowerShell
{
    $a = &quot;b&quot;
    $a === &quot;b&quot;
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
EqualityTypeComparison [-AssignmentStatementAST] &lt;AssignmentStatementAst&gt; [&lt;CommonParameters&gt;]
```
---
### Notes
This will not work if there is a constant on both sides of the expression


if ($one === $one) { "this will work"} 
if ('' === '')     { "this will not"}





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
> EXAMPLE 1

```PowerShell
Invoke-PipeScript -ScriptBlock {
    $a = 1    
    if ($a == 1 ) {
        "A is $a"
    }
}
```
> EXAMPLE 2

```PowerShell
{
    $a == "b"
} | .>PipeScript
```

---

### Parameters
#### **AssignmentStatementAST**
The original assignment statement.

|Type                      |Required|Position|PipelineInput |
|--------------------------|--------|--------|--------------|
|`[AssignmentStatementAst]`|true    |1       |true (ByValue)|

---

### Notes
This will not work if there is a constant on both sides of the expression

if ($null == $null) { "this will work"} 
if ('' == '') { "this will not"}

---

### Syntax
```PowerShell
EqualityComparison [-AssignmentStatementAST] <AssignmentStatementAst> [<CommonParameters>]
```

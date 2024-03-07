Template.PipeScript.TripleEqualCompare
--------------------------------------

### Synopsis
Allows equality type comparison.

---

### Description

Allows most equality comparison using triple equals (===).

Many languages support this syntax.  PowerShell does not.    

This transpiler enables equality and type comparison with ===.

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript -ScriptBlock {
    $a = 1
    $number = 1    
    if ($a === $number ) {
        "A is $a"
    }
}
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript -ScriptBlock {
    $One = 1
    $OneIsNotANumber = "1"
    if ($one == $OneIsNotANumber) {
        'With ==, a number can be compared to a string, so $a == "1"'
    }
    if (-not ($One === $OneIsNotANumber)) {
        "With ===, a number isn't the same type as a string, so this will be false."            
    }
}
```
> EXAMPLE 3

```PowerShell
Invoke-PipeScript -ScriptBlock {
    if ($null === $null) {
        '$Null really is $null'
    }
}
```
> EXAMPLE 4

```PowerShell
Invoke-PipeScript -ScriptBlock {
    $zero = 0
    if (-not ($zero === $null)) {
        '$zero is not $null'
    }
}
```
> EXAMPLE 5

```PowerShell
{
    $a = "b"
    $a === "b"
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

if ($one === $one) { "this will work"} 
if ('' === '')     { "this will not"}

---

### Syntax
```PowerShell
Template.PipeScript.TripleEqualCompare [-AssignmentStatementAST] <AssignmentStatementAst> [<CommonParameters>]
```

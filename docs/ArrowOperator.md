ArrowOperator
-------------

### Synopsis
Arrow Operator

---

### Description

Many languages support an arrow operator natively.  PowerShell does not.

PipeScript's arrow operator works similarly to lambda expressions in C# or arrow operators in JavaScript:

---

### Examples
> EXAMPLE 1

```PowerShell
$allTypes = 
    Invoke-PipeScript {
        [AppDomain]::CurrentDomain.GetAssemblies() => $_.GetTypes()
    }
$allTypes.Count # Should -BeGreaterThan 1kb
$allTypes # Should -BeOfType ([Type])
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript {
    Get-Process -ID $PID => ($Name, $Id, $StartTime) => { "$Name [$ID] $StartTime"}
} # Should -Match "$pid"
```
> EXAMPLE 3

```PowerShell
Invoke-PipeScript {
    func => ($Name, $Id) { $Name, $Id}
} # Should -BeOfType ([ScriptBlock])
```

---

### Parameters
#### **ArrowStatementAst**
The Arrow Operator can be part of a statement, for example:
~~~PowerShell
Invoke-PipeScript { [AppDomain]::CurrentDomain.GetAssemblies() => $_.GetTypes() } 
~~~
The -ArrowStatementAst is the assignment statement that uses the arrow operator.

|Type                      |Required|Position|PipelineInput |
|--------------------------|--------|--------|--------------|
|`[AssignmentStatementAst]`|true    |named   |true (ByValue)|

#### **ArrowCommandAst**
The Arrow Operator can occur within a command, for example:
~~~PowerShell
Invoke-PipeScript {
    Get-Process -Id $pid => ($Name,$ID,$StartTime) => { "$Name [$ID] @ $StartTime" }
}
~~~

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
ArrowOperator -ArrowStatementAst <AssignmentStatementAst> [<CommonParameters>]
```
```PowerShell
ArrowOperator -ArrowCommandAst <CommandAst> [<CommonParameters>]
```

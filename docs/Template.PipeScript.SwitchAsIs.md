Template.PipeScript.SwitchAsIs
------------------------------

### Synopsis
Switches based off of type, using as or is

---

### Description

Slightly rewrites a switch statement that is written with full typenames.

Normally, PowerShell would try to match the typename as a literal string, which is highly unlikely to work.

SwitchAsIs will take a switch statement in the form of:

~~~PowerShell
switch ($t) {
    [typeName] {
        
    }
}
~~~

And rewrite it to use the casting operators

If the label matches As or Is, it will use the corresponding operators.

---

### Examples
> EXAMPLE 1

```PowerShell
1..10 | Invoke-PipeScript {
    switch ($_) {
        [int] { $_ } 
        [double] { $_ }
    }
}
```

---

### Parameters
#### **SwitchStatementAst**
The switch statement

|Type                  |Required|Position|PipelineInput |
|----------------------|--------|--------|--------------|
|`[SwitchStatementAst]`|false   |1       |true (ByValue)|

---

### Syntax
```PowerShell
Template.PipeScript.SwitchAsIs [[-SwitchStatementAst] <SwitchStatementAst>] [<CommonParameters>]
```

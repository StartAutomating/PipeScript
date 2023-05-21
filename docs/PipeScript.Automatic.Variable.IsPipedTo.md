PipeScript.Automatic.Variable.IsPipedTo
---------------------------------------




### Synopsis
$IsPipedTo



---


### Description

$IsPipedTo is an automatic variable that determines if a command is being piped to.



---


### Examples
#### EXAMPLE 1
```PowerShell
& (Use-PipeScript { $IsPipedTo }) # Should -Be $False
```

#### EXAMPLE 2
```PowerShell
1 | & (Use-PipeScript { $IsPipedTo }) # Should -Be $True
```



---


### Syntax
```PowerShell
PipeScript.Automatic.Variable.IsPipedTo [<CommonParameters>]
```

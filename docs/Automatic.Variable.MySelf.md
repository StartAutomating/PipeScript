Automatic.Variable.MySelf
-------------------------




### Synopsis
$MySelf



---


### Description

$MySelf is an automatic variable that contains the currently executing ScriptBlock.
A Command can & $myself to use anonymous recursion.



---


### Examples
#### EXAMPLE 1
```PowerShell
{
    $mySelf
} | Use-PipeScript
```

#### EXAMPLE 2
```PowerShell
Invoke-PipeScript {
    param($n = 1)
    if ($n -gt 0) {
        $n + (& $myself ($n + 1))
    }
} -ArgumentList 3
```



---


### Syntax
```PowerShell
Automatic.Variable.MySelf [<CommonParameters>]
```

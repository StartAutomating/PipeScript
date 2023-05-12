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



---


### Syntax
```PowerShell
Automatic.Variable.MySelf [<CommonParameters>]
```

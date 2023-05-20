Automatic.Variable.MyParameters
-------------------------------




### Synopsis
$MyParameters



---


### Description

$MyParameters is an automatic variable that is a copy of $psBoundParameters.
This leaves you more free to change it.



---


### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript -ScriptBlock {
    $MyParameters
}
```



---


### Syntax
```PowerShell
Automatic.Variable.MyParameters [<CommonParameters>]
```

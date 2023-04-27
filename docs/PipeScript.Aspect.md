PipeScript.Aspect
-----------------




### Synopsis
Aspect Transpiler



---


### Description

The Aspect Transpiler allows for any Aspect command to be embedded inline anywhere the aspect is found.



---


### Examples
#### EXAMPLE 1
```PowerShell
Import-PipeScript {
    aspect function SayHi {
        if (-not $args) { "Hello World"}
        else { $args }
    }
    function Greetings {
        SayHi
        SayHi "hallo Welt"
    }
}
```
Greetings


---


### Parameters
#### **AspectCommandAst**

An Aspect Command.  Aspect Commands are embedded inline.






|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|





---


### Syntax
```PowerShell
PipeScript.Aspect [-AspectCommandAst] <CommandAst> [<CommonParameters>]
```

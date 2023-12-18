PipeScript.Aspect
-----------------

### Synopsis
Aspect Transpiler

---

### Description

The Aspect Transpiler allows for any Aspect command to be embedded inline anywhere the aspect is found.

Aspects enable aspect-oriented programming in PipeScript.

Aspects should be small self-contained functions that solve one "aspect" of a problem.

---

### Examples
> EXAMPLE 1

```PowerShell
Import-PipeScript {
    aspect function SayHi {
        if (-not $args) { "Hello World"}
        else { $args }
    }
    function Greetings {
        SayHi # Aspects can be referred to by their short name
        Aspect.SayHi "hallo Welt" # or their long name
    }
}
Greetings
```

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

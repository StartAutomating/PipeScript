PipeScript.PostProcess.PartialFunction
--------------------------------------

### Synopsis
Expands partial functions

---

### Description

A partial function is a function that will be joined with a function with a matching name.

---

### Related Links
* [Join-PipeScript](Join-PipeScript.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Import-PipeScript {
    partial function testPartialFunction {
        "This will be added to a command name TestPartialFunction"
    }
    
    function testPartialFunction {}
}
testPartialFunction # Should -BeLike '*TestPartialFunction*'
```

---

### Parameters
#### **FunctionDefinitionAst**
The function definition.

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[FunctionDefinitionAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.PostProcess.PartialFunction -FunctionDefinitionAst <FunctionDefinitionAst> [<CommonParameters>]
```

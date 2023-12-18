System.Management.Automation.Language.Ast.get_Defines()
-------------------------------------------------------

### Synopsis
Gets all Definitions within an AST

---

### Description

Gets all Function and Type Definitions and Parameters within a PowerShell Abstract Syntax Tree

---

### Examples
> EXAMPLE 1

```PowerShell
{function foo() { "foo"} class bar { $bar = "none"} }.Ast.Defines
```

---

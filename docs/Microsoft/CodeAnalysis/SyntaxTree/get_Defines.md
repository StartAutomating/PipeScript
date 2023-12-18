Microsoft.CodeAnalysis.SyntaxTree.get_Defines()
-----------------------------------------------

### Synopsis
Gets all Definitions within an AST

---

### Description

Gets all Class and Type Definitions within a CSharp Abstract Syntax Tree

---

### Examples
> EXAMPLE 1

```PowerShell
Parse-CSharp ('
    public class MyClass {
        public void MyMethod();    
    }
').Defines
```

---

Microsoft.CodeAnalysis.SyntaxNode.get_Variables()
-------------------------------------------------

### Synopsis
Gets all Variables within an AST

---

### Description

Gets all Variable and Field Definitions within a CSharp Abstract Syntax Tree

---

### Examples
> EXAMPLE 1

```PowerShell
Parse-CSharp ('
    public class MyClass {
        public void MyMethod() {
            string bar = "bar";
        }
        public int foo = 1;
    }
').Variables
```

---

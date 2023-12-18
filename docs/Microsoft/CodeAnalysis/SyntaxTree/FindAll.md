Microsoft.CodeAnalysis.SyntaxTree.FindAll()
-------------------------------------------

### Synopsis
Finds all CSharp Nodes

---

### Description

Finds all CSharp Syntax Nodes that meet any one of a number of criteria

---

### Examples
> EXAMPLE 1

```PowerShell
(Parse-CSharp 'Console.WriteLine("Hello World");').FindAll("*hello*")
```

---

Microsoft.CodeAnalysis.SyntaxTree.Find()
----------------------------------------

### Synopsis
Finds a CSharp Node

---

### Description

Finds a single CSharp Syntax Node that meets any one of a number of criteria

---

### Examples
> EXAMPLE 1

```PowerShell
(Parse-CSharp 'Console.WriteLine("Hello World");').Find("*hello*")
```

---

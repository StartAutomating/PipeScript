Language.Cuda
-------------

### Synopsis
Cuda PipeScript Language Definition.

---

### Description

Allows PipeScript to generate Cuda.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.    

The Cuda Inline PipeScript Transpiler will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.Cuda [<CommonParameters>]
```

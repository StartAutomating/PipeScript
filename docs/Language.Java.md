Language.Java
-------------

### Synopsis
Java PipeScript Language Definition.

---

### Description

Allows PipeScript to generate Java.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.    

The Java Inline PipeScript Transpiler will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.Java [<CommonParameters>]
```

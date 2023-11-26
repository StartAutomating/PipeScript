Language.ObjectiveC
-------------------

### Synopsis
Objective-C Language Definition.

---

### Description

Allows PipeScript to generate Objective C/C++.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The Objective C Inline Transpiler will consider the following syntax to be empty:

* ```null```
* ```nil```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.ObjectiveC [<CommonParameters>]
```

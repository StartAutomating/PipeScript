Language.Arduino
----------------

### Synopsis
Arduino Language Definition

---

### Description

Defines Arduino within PipeScript.

This allows Arduino to be templated.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The C++ Inline Transpiler will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.Arduino [<CommonParameters>]
```

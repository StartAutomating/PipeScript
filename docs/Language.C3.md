Language.C3
-----------

### Synopsis
PipeScript C3 Language Definition.

---

### Description

Allows PipeScript to generate C3 files.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The C3 will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.C3 [<CommonParameters>]
```

Language.Kotlin
---------------

### Synopsis
Kotlin PipeScript Language Definition.

---

### Description

Allows PipeScript to generate Kotlin.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The Kotlin Inline PipeScript Transpiler will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.Kotlin [<CommonParameters>]
```

Language.Kusto
--------------

### Synopsis
Kusto PipeScript Language Defintion.

---

### Description

Allows PipeScript to generate Kusto files.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The Kusto Template Transpiler will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.Kusto [<CommonParameters>]
```

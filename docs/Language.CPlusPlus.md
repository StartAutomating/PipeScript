Language.CPlusPlus
------------------

### Synopsis
C++ Language Definition.

---

### Description

Allows PipeScript to generate C++, Header or Swig files.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The within C++, PipeScript will consider the following syntax to be empty:

* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.CPlusPlus [<CommonParameters>]
```

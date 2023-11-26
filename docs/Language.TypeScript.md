Language.TypeScript
-------------------

### Synopsis
TypeScript Language Definition.

---

### Description

Allows PipeScript to generate TypeScript.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This is so that Inline PipeScript can be used with operators, and still be valid TypeScript syntax. 

The TypeScript Inline Transpiler will consider the following syntax to be empty:

* ```undefined```
* ```null```
* ```""```
* ```''```

---

### Syntax
```PowerShell
Language.TypeScript [<CommonParameters>]
```

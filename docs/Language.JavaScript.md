Language.JavaScript
-------------------

### Synopsis
JavaScript PipeScript Language Definition.

---

### Description

Allows PipeScript to generate JavaScript.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

String output from these blocks will be embedded directly.  All other output will be converted to JSON.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

The JavaScript Inline Transpiler will consider the following syntax to be empty:

* ```undefined```
* ```null```
* ```""```
* ```''```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    Hello.js template '
    msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
    if (console) {
        console.log(msg);
    }
    '
    
}
```
> EXAMPLE 2

```PowerShell
Invoke-PipeScript {
    $helloMsg = {param($msg = 'hello world') "`"$msg`""}
    $helloJs = HelloWorld.js template "
    msg = null /*{$helloMsg}*/;
    if (console) {
        console.log(msg);
    }
    "
    $helloJs
}
```
> EXAMPLE 3

```PowerShell
.\Hello.js
Invoke-PipeScript .\Hello.js
```

---

### Syntax
```PowerShell
Language.JavaScript [<CommonParameters>]
```

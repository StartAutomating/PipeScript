JavaScript.Template
-------------------
### Synopsis
JavaScript Template Transpiler.

---
### Description

Allows PipeScript to generate JavaScript.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This is so that Inline PipeScript can be used with operators, and still be valid JavaScript syntax.

The JavaScript Inline Transpiler will consider the following syntax to be empty:

* ```undefined```
* ```null```
* ```""```
* ```''```

---
### Examples
#### EXAMPLE 1
```PowerShell
$helloJs = Hello.js template '
msg = null /*{param($msg = ''hello world'') "`"$msg`""}*/ ;
if (console) {
    console.log(msg);
}
'
```

#### EXAMPLE 2
```PowerShell
$helloMsg = {param($msg = 'hello world') "`"$msg`""}
$helloJs = HelloWorld.js template "
msg = null /*{$helloMsg}*/;
if (console) {
    console.log(msg);
}
"
```

---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
JavaScript.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
JavaScript.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---


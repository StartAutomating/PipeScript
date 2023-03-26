JavaScript.Template
-------------------




### Synopsis
JavaScript Template Transpiler.



---


### Description

Allows PipeScript to generate JavaScript.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

String output from these blocks will be embedded directly.  All other output will be converted to JSON.

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






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|



#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |



#### **Parameter**

A dictionary of parameters.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



#### **ArgumentList**

A list of arguments.






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |





---


### Syntax
```PowerShell
JavaScript.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
JavaScript.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```


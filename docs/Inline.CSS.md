
Inline.CSS
----------
### Synopsis
CSS Inline PipeScript Transpiler.

---
### Description

Transpiles CSS with Inline PipeScript into CSS.

Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

This for Inline PipeScript to be used with operators, and still be valid CSS syntax. 

The CSS Inline Transpiler will consider the following syntax to be empty:

* ```(?<q>["'])\#[a-f0-9]{3}(\k<q>)```
* ```\#[a-f0-9]{6}```
* ```[\d\.](?>pt|px|em)```
* ```auto```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $StyleSheet = @&#39;
MyClass {
text-color: &quot;#000000&quot; /*{
&quot;&#39;red&#39;&quot;, &quot;&#39;green&#39;&quot;,&quot;&#39;blue&#39;&quot; | Get-Random
}*/;
}
&#39;@
    [Save(&quot;.\StyleSheet.ps1.css&quot;)]$StyleSheet
}
```
.> .\StyleSheet.ps1.css
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.CSS [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




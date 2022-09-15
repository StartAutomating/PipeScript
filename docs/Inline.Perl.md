
Inline.Perl
-----------
### Synopsis
Perl Inline PipeScript Transpiler.

---
### Description

Transpiles Perl with Inline PipeScript into Perl.

Also Transpiles Plain Old Document

PipeScript can be embedded in a Plain Old Document block that starts with ```=begin PipeScript``` and ends with ```=end PipeScript```.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $HelloWorldPerl = @&#39;
=begin PipeScript
$msg = &quot;hello&quot;, &quot;hi&quot;, &quot;hey&quot;, &quot;howdy&quot; | Get-Random
&quot;print(&quot; + &#39;&quot;&#39; + $msg + &#39;&quot;);&#39;
=end   PipeScript
&#39;@
```
[Save(".\HelloWorld.ps1.pl")]$HelloWorldPerl
}

.> .\HelloWorld.ps1.pl
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
Inline.Perl [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




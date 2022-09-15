
Inline.TOML
-----------
### Synopsis
TOML Inline PipeScript Transpiler.

---
### Description

Transpiles TOML with Inline PipeScript into TOML.

Because TOML does not support comment blocks, PipeScript can be written inline inside of specialized Multiline string

PipeScript can be included in a TOML string that starts and ends with ```{}```, for example ```"""{}"""```

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $tomlContent = @&#39;
[seed]
RandomNumber = &quot;&quot;&quot;{Get-Random}&quot;&quot;&quot;
&#39;@
    [OutputFile(&#39;.\RandomExample.ps1.toml&#39;)]$tomlContent
}
```
.> .\RandomExample.ps1.toml
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
Inline.TOML [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---





Help
----
### Synopsis
Help Transpiler

---
### Description

The Help Transpiler allows you to write inline help without directly writing comments.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    [Help(Synopsis=&quot;The Synopsis&quot;, Description=&quot;A Description&quot;)]
    param()
```
"This Script Has Help, Without Directly Writing Comments"
    
} | .>PipeScript
#### EXAMPLE 2
```PowerShell
{
    param(
    [Help(Synopsis=&quot;X Value&quot;)]
    $x
    )
} | .&gt;PipeScript
```

#### EXAMPLE 3
```PowerShell
{
    param(
    [Help(&quot;X Value&quot;)]
    $x
    )
} | .&gt;PipeScript
```

---
### Parameters
#### **Synopsis**

> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **Description**

> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Example**

> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Link**

> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ScriptBlock**

> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Help [-Synopsis] &lt;String&gt; [-Description &lt;String&gt;] [-Example &lt;String[]&gt;] [-Link &lt;String[]&gt;] [&lt;CommonParameters&gt;]
```
```PowerShell
Help [-Synopsis] &lt;String&gt; [-Description &lt;String&gt;] [-Example &lt;String[]&gt;] [-Link &lt;String[]&gt;] [-ScriptBlock &lt;ScriptBlock&gt;] [&lt;CommonParameters&gt;]
```
---




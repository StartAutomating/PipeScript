
ProxyCommand
------------
### Synopsis
Creates Proxy Commands

---
### Description

Generates a Proxy Command for an underlying PowerShell or PipeScript command.

---
### Examples
#### EXAMPLE 1
```PowerShell
.\ProxyCommand.psx.ps1 -CommandName Get-Process
```

#### EXAMPLE 2
```PowerShell
{
    function [ProxyCommand&lt;&#39;Get-Process&#39;&gt;]GetProcessProxy {}
} | .&gt;PipeScript
```

#### EXAMPLE 3
```PowerShell
ProxyCommand -CommandName Get-Process -RemoveParameter *
```

#### EXAMPLE 4
```PowerShell
Invoke-PipeScript -ScriptBlock {[ProxyCommand(&#39;Get-Process&#39;)]param()}
```

#### EXAMPLE 5
```PowerShell
Invoke-PipeScript -ScriptBlock {
    [ProxyCommand(&#39;Get-Process&#39;, 
        RemoveParameter=&#39;*&#39;,
        DefaultParameter={
            @{id=&#39;$pid&#39;}
        })]
        param()
}
```

#### EXAMPLE 6
```PowerShell
{ 
    function Get-MyProcess {
        [ProxyCommand(&#39;Get-Process&#39;, 
            RemoveParameter=&#39;*&#39;,
            DefaultParameter={
                @{id=&#39;$pid&#39;}
            })]
            param()
    } 
} | .&gt;PipeScript
```

---
### Parameters
#### **ScriptBlock**

The ScriptBlock that will become a proxy command.  This should be empty, since it is ignored.



> **Type**: ```[ScriptBlock]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **CommandName**

The name of the command being proxied.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **RemoveParameter**

If provided, will remove any number of parameters from the proxy command.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **DefaultParameter**

Any default parameters for the ProxyCommand.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
ProxyCommand [-ScriptBlock &lt;ScriptBlock&gt;] [-CommandName] &lt;String&gt; [-RemoveParameter &lt;String[]&gt;] [-DefaultParameter &lt;IDictionary&gt;] [&lt;CommonParameters&gt;]
```
---




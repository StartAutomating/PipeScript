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
    function [ProxyCommand<'Get-Process'>]GetProcessProxy {}
} | .>PipeScript
```

#### EXAMPLE 3
```PowerShell
ProxyCommand -CommandName Get-Process -RemoveParameter *
```

#### EXAMPLE 4
```PowerShell
Invoke-PipeScript -ScriptBlock {[ProxyCommand('Get-Process')]param()}
```

#### EXAMPLE 5
```PowerShell
Invoke-PipeScript -ScriptBlock {
    [ProxyCommand('Get-Process', 
        RemoveParameter='*',
        DefaultParameter={
            @{id='$pid'}
        })]
        param()
}
```

#### EXAMPLE 6
```PowerShell
{ 
    function Get-MyProcess {
        [ProxyCommand('Get-Process', 
            RemoveParameter='*',
            DefaultParameter={
                @{id='$pid'}
            })]
            param()
    } 
} | .>PipeScript
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
ProxyCommand [-ScriptBlock <ScriptBlock>] [-CommandName] <String> [-RemoveParameter <String[]>] [-DefaultParameter <IDictionary>] [<CommonParameters>]
```
---


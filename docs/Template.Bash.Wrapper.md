Template.Bash.Wrapper
---------------------

### Synopsis
Wraps PowerShell in a Bash Script

---

### Description

Wraps PowerShell in a Bash Script

---

### Parameters
#### **ScriptInfo**

|Type                  |Required|Position|PipelineInput |
|----------------------|--------|--------|--------------|
|`[ExternalScriptInfo]`|true    |named   |true (ByValue)|

#### **ScriptBlock**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
Template.Bash.Wrapper -ScriptInfo <ExternalScriptInfo> [<CommonParameters>]
```
```PowerShell
Template.Bash.Wrapper -ScriptBlock <ScriptBlock> [<CommonParameters>]
```

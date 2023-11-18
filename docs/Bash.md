Bash
----

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
Bash -ScriptInfo <ExternalScriptInfo> [<CommonParameters>]
```
```PowerShell
Bash -ScriptBlock <ScriptBlock> [<CommonParameters>]
```

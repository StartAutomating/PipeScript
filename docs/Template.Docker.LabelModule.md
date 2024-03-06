Template.Docker.LabelModule
---------------------------

### Synopsis
Labels a docker image from a module.

---

### Description

Applies labels to a docker image from module metadata.

---

### Parameters
#### **Module**
The module to label.

|Type            |Required|Position|PipelineInput |
|----------------|--------|--------|--------------|
|`[PSModuleInfo]`|false   |1       |true (ByValue)|

---

### Syntax
```PowerShell
Template.Docker.LabelModule [[-Module] <PSModuleInfo>] [<CommonParameters>]
```

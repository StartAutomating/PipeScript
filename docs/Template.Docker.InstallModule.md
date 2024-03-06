Template.Docker.InstallModule
-----------------------------

### Synopsis
Template for installing a PowerShell module in a Dockerfile.

---

### Description

A Template for installing a PowerShell module in a Dockerfile.

---

### Parameters
#### **ModuleName**
The module to install.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **ModuleVersion**
The version of the module to install.

|Type       |Required|Position|PipelineInput        |
|-----------|--------|--------|---------------------|
|`[Version]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.InstallModule [[-ModuleName] <String>] [[-ModuleVersion] <Version>] [<CommonParameters>]
```

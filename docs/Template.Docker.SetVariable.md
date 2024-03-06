Template.Docker.SetVariable
---------------------------

### Synopsis
Template for setting a variable in a Dockerfile.

---

### Description

A Template for setting a variable in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#env](https://docs.docker.com/engine/reference/builder/#env)

---

### Parameters
#### **Name**
The name of the variable to set.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Value**
The value to set the variable to.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.SetVariable [[-Name] <String>] [[-Value] <String>] [<CommonParameters>]
```

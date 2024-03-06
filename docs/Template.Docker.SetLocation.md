Template.Docker.SetLocation
---------------------------

### Synopsis
Template for setting the working directory in a Dockerfile.

---

### Description

A Template for setting the working directory in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#workdir](https://docs.docker.com/engine/reference/builder/#workdir)

---

### Parameters
#### **Path**
The path to set as the working directory.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.SetLocation [[-Path] <String>] [<CommonParameters>]
```

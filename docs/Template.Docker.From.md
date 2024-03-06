Template.Docker.From
--------------------

### Synopsis
Template for a Dockerfile FROM statement.

---

### Description

A Template for a Dockerfile FROM statement.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#from](https://docs.docker.com/engine/reference/builder/#from)

---

### Parameters
#### **BaseImage**
The base image to use.  By default, mcr.microsoft.com/powershell.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.From [[-BaseImage] <String>] [<CommonParameters>]
```

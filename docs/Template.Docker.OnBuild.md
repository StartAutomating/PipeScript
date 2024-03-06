Template.Docker.OnBuild
-----------------------

### Synopsis
Template for running a command in the build of a Dockerfile.

---

### Description

A Template for running a command in the build of this image in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#onbuild](https://docs.docker.com/engine/reference/builder/#onbuild)

---

### Parameters
#### **Command**
The command to run.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.OnBuild [[-Command] <String>] [<CommonParameters>]
```

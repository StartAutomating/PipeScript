Template.Docker.SetShell
------------------------

### Synopsis
Template for setting the shell in a Dockerfile.

---

### Description

A Template for setting the shell in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#shell](https://docs.docker.com/engine/reference/builder/#shell)

---

### Parameters
#### **Shell**
The shell to set.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Argument**
The arguments to pass to the shell.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |2       |false        |

---

### Syntax
```PowerShell
Template.Docker.SetShell [[-Shell] <String>] [[-Argument] <String[]>] [<CommonParameters>]
```

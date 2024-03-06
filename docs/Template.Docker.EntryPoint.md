Template.Docker.EntryPoint
--------------------------

### Synopsis
Template for a Dockerfile ENTRYPOINT statement.

---

### Description

A Template for a Dockerfile ENTRYPOINT statement.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint)

---

### Parameters
#### **Command**
The command to run when the container starts.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Argument**
The arguments to pass to the command.

|Type        |Required|Position|PipelineInput        |Aliases                            |
|------------|--------|--------|---------------------|-----------------------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|Arguments<br/>Args<br/>ArgumentList|

---

### Syntax
```PowerShell
Template.Docker.EntryPoint [[-Command] <String>] [[-Argument] <String[]>] [<CommonParameters>]
```

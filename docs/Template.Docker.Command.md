Template.Docker.Command
-----------------------

### Synopsis
Template for running a command in a Dockerfile.

---

### Description

The CMD instruction sets the command to be executed when running a container from an image.

There can only be one command. If you list more than one command, only the last one will take effect.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#cmd](https://docs.docker.com/engine/reference/builder/#cmd)

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
Template.Docker.Command [[-Command] <String>] [<CommonParameters>]
```

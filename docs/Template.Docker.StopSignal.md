Template.Docker.StopSignal
--------------------------

### Synopsis
Template for setting the stop signal in a Dockerfile.

---

### Description

A Template for setting the stop signal in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#stopsignal](https://docs.docker.com/engine/reference/builder/#stopsignal)

---

### Parameters
#### **Signal**
The signal to stop the container.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.StopSignal [[-Signal] <String>] [<CommonParameters>]
```

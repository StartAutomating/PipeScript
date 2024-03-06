Template.Docker.Expose
----------------------

### Synopsis
Template for exposing a port in a Dockerfile.

---

### Description

A Template for exposing a port in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#expose](https://docs.docker.com/engine/reference/builder/#expose)

---

### Parameters
#### **Port**
The port to expose. By default, 80.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |1       |true (ByPropertyName)|

#### **Protocol**
The protocol to expose. By default, tcp.
Valid Values:

* tcp
* udp

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

---

### Syntax
```PowerShell
Template.Docker.Expose [[-Port] <Int32>] [[-Protocol] <String>] [<CommonParameters>]
```

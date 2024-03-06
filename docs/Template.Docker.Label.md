Template.Docker.Label
---------------------

### Synopsis
Template for setting a label in a Dockerfile.

---

### Description

A Template for setting a label in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#label](https://docs.docker.com/engine/reference/builder/#label)

---

### Parameters
#### **Label**
The label to set.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Value**
The value of the label.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.Label [[-Label] <String>] [[-Value] <String>] [<CommonParameters>]
```

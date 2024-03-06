Template.Docker.CopyItem
------------------------

### Synopsis
Template for copying an item in a Dockerfile.

---

### Description

A Template for copying an item in a Dockerfile.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#copy](https://docs.docker.com/engine/reference/builder/#copy)

---

### Parameters
#### **Source**
The source item to copy.

|Type      |Required|Position|PipelineInput        |Aliases                  |
|----------|--------|--------|---------------------|-------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|SourcePath<br/>SourceItem|

#### **Destination**
The destination to copy the item to.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.Docker.CopyItem [[-Source] <String>] [[-Destination] <String>] [<CommonParameters>]
```

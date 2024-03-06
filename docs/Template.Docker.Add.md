Template.Docker.Add
-------------------

### Synopsis
Template for adding files to a Docker image.

---

### Description

A Template for adding files to a Docker image.

---

### Related Links
* [https://docs.docker.com/engine/reference/builder/#add](https://docs.docker.com/engine/reference/builder/#add)

---

### Parameters
#### **Source**
The source of the file to add.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Destination**
The destination of the file to add.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **KeepGit**
Keep git directory

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Checksum**
Verify the checksum of the file

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **ChangeOwner**
Change the owner permissions

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |4       |true (ByPropertyName)|Chown  |

---

### Syntax
```PowerShell
Template.Docker.Add [[-Source] <String>] [[-Destination] <String>] [-KeepGit] [[-Checksum] <String>] [[-ChangeOwner] <String>] [<CommonParameters>]
```

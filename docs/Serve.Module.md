Serve.Module
------------

### Synopsis
Serves a Module

---

### Description

Services a request to a module.

This should first attempt to call any of the module's routes,
Then attempt to find an appropriate topic.
Then return the default module topic.

---

### Parameters
#### **Module**
The module being served

|Type            |Required|Position|PipelineInput |
|----------------|--------|--------|--------------|
|`[PSModuleInfo]`|true    |1       |true (ByValue)|

#### **Request**
The request object.
This should generally not be provided, as it will be provided by the server.
(it can be provided for testing purposes)

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Serve.Module [-Module] <PSModuleInfo> [[-Request] <PSObject>] [<CommonParameters>]
```

Serve.Variable
--------------

### Synopsis
Serves variables.

---

### Description

Serves variables from a module.

---

### Parameters
#### **Variable**
The list of variables to serve

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|true    |1       |true (ByValue)|

#### **Module**
The module containing the variables.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |2       |true (ByPropertyName)|

#### **Request**
The request object.
This should generally not be provided, as it will be provided by the server.
(it can be provided for testing purposes)

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |3       |true (ByPropertyName)|

---

### Notes
This service allows select variables to be served from a module.

It does not allow for patterns of variables to be served.

Additionally, it will not allow the variable to be changed (only viewed)

---

### Syntax
```PowerShell
Serve.Variable [-Variable] <PSObject[]> [[-Module] <PSObject>] [[-Request] <PSObject>] [<CommonParameters>]
```

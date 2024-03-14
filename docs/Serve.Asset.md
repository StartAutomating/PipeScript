Serve.Asset
-----------

### Synopsis
Serves asset files.

---

### Description

Serves asset files.

These files will not be run, but will be served as static files.

One or more extensions can be provided.

Any file that matches these extensions will be served.

---

### Parameters
#### **Extension**
The list of extensions to serve as assets

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|true    |1       |true (ByValue)|

#### **Module**
The module containing the assets.

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
This service allows asset files to be served from a module without exposing the file system.

---

### Syntax
```PowerShell
Serve.Asset [-Extension] <PSObject[]> [[-Module] <PSObject>] [[-Request] <PSObject>] [<CommonParameters>]
```

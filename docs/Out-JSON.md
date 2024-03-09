Out-JSON
--------

### Synopsis
Outputs objects as JSON

---

### Description

Outputs objects in JSON.

If only one object is outputted, it will not be in a list.
If multiple objects are outputted, they will be in a list.

---

### Related Links
* [@{
    a = 'b'
} | Out-JSON](@{
    a = 'b'
} | Out-JSON.md)

---

### Parameters
#### **InputObject**
The input object.  This will form the majority of the JSON.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |named   |true (ByValue)|

#### **ArgumentList**
Any arguments.  These will be appended to the input.

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |

#### **Depth**
The depth of the JSON.  By default, this is the FormatEnumerationLimit.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |

---

### Syntax
```PowerShell
Out-JSON [-InputObject <PSObject>] [-ArgumentList <PSObject[]>] [-Depth <Int32>] [<CommonParameters>]
```

System.Management.Automation.PSMemberSet.propertyIsEnumerable()
---------------------------------------------------------------

### Synopsis
Determines if a property is enumerable

---

### Description

Determines if a property or object is enumerable.    

If no PropertyName is provided, this method will determine if the .ImmediateBaseObject is enumerable.

---

### Parameters
#### **PropertyName**
The property name.
If this is not provided, this method will determine if the .ImmediateBaseObject is enumerable.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

---

### Notes
This makes .PSObject more similar to a JavaScript prototype.

---

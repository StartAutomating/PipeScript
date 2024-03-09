Template.PowerShell.Attribute
-----------------------------

### Synopsis
Template for a PowerShell Attribute

---

### Description

Writes a value as a PowerShell attribute.

---

### Examples
> EXAMPLE 1

[ValidateSet('a','b','c')] | Template.PowerShell.Attribute
> EXAMPLE 2

```PowerShell
Template.PowerShell.Attribute -Type "MyCustomAttribute" -Argument 1,2,3 -Parameter @{Name='Value';Value='Data'}
```

---

### Parameters
#### **Type**
The type of the attribute.  This does not have to exist (yet).

|Type        |Required|Position|PipelineInput        |Aliases                 |
|------------|--------|--------|---------------------|------------------------|
|`[PSObject]`|false   |1       |true (ByPropertyName)|TypeID<br/>AttributeType|

#### **ArgumentList**
Any arguments to the attribute.  These will be passed as constructors.

|Type          |Required|Position|PipelineInput        |Aliases                                                                                                                                                     |
|--------------|--------|--------|---------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[PSObject[]]`|false   |2       |true (ByPropertyName)|Args<br/>Argument<br/>Arguments<br/>Constructor<br/>Constructors<br/>AttributeArgs<br/>AttributeArguments<br/>AttributeConstructor<br/>AttributeConstructors|

#### **Parameter**
Any parameters to the attribute.  These will be passed as properties.

|Type          |Required|Position|PipelineInput        |Aliases                                                                             |
|--------------|--------|--------|---------------------|------------------------------------------------------------------------------------|
|`[PSObject[]]`|false   |3       |true (ByPropertyName)|AttributeData<br/>AttributeParameter<br/>AttributeParameters<br/>Parameters<br/>Data|

---

### Notes
This does not check that the type actually exists yet, because it may not.

---

### Syntax
```PowerShell
Template.PowerShell.Attribute [[-Type] <PSObject>] [[-ArgumentList] <PSObject[]>] [[-Parameter] <PSObject[]>] [<CommonParameters>]
```

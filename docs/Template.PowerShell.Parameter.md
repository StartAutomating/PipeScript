Template.PowerShell.Parameter
-----------------------------

### Synopsis
PowerShell Parameter Template

---

### Description

Generates a parameter declaration for a PowerShell function.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.PowerShell.Parameter -Name "MyParameter" -Type "string" -DefaultValue "MyDefaultValue" -Description "My Description"
```

---

### Parameters
#### **Name**
The name of the parameter.

|Type        |Required|Position|PipelineInput        |Aliases      |
|------------|--------|--------|---------------------|-------------|
|`[PSObject]`|false   |1       |true (ByPropertyName)|ParameterName|

#### **ParameterAttribute**
Any parameter attributes.
These will appear first.

|Type          |Required|Position|PipelineInput        |Aliases            |
|--------------|--------|--------|---------------------|-------------------|
|`[PSObject[]]`|false   |2       |true (ByPropertyName)|ParameterAttributes|

#### **Alias**
Any parameter aliases
These will appear beneath parameter attributes.

|Type          |Required|Position|PipelineInput        |Aliases                             |
|--------------|--------|--------|---------------------|------------------------------------|
|`[PSObject[]]`|false   |3       |true (ByPropertyName)|Aliases<br/>AliasName<br/>AliasNames|

#### **Attribute**
Any other attributes.  These will appear directly above the type and name.

|Type          |Required|Position|PipelineInput        |Aliases   |
|--------------|--------|--------|---------------------|----------|
|`[PSObject[]]`|false   |4       |true (ByPropertyName)|Attributes|

#### **Type**
One or more parameter types.

|Type          |Required|Position|PipelineInput        |Aliases                         |
|--------------|--------|--------|---------------------|--------------------------------|
|`[PSObject[]]`|false   |5       |true (ByPropertyName)|ParameterType<br/>ParameterTypes|

#### **DefaultValue**
One or more default values (if more than one default value is provided, it will be assumed to be an array)

|Type        |Required|Position|PipelineInput        |Aliases                                               |
|------------|--------|--------|---------------------|------------------------------------------------------|
|`[PSObject]`|false   |6       |true (ByPropertyName)|Default<br/>ParameterDefault<br/>ParameterDefaultValue|

#### **ValidateSet**
A valid set of values

|Type          |Required|Position|PipelineInput        |Aliases                   |
|--------------|--------|--------|---------------------|--------------------------|
|`[PSObject[]]`|false   |7       |true (ByPropertyName)|ValidValue<br/>ValidValues|

#### **Description**
The Parameter description (any help for the parameter)

|Type          |Required|Position|PipelineInput        |Aliases                                        |
|--------------|--------|--------|---------------------|-----------------------------------------------|
|`[PSObject[]]`|false   |8       |true (ByPropertyName)|Help<br/>ParameterHelp<br/>Synopsis<br/>Summary|

#### **Binding**
Any simple bindings for the parameter.
These are often used to describe the name of a parameter in an underlying system.
For example, a parameter might be named "Name" in PowerShell, but "itemName" in JSON.

|Type        |Required|Position|PipelineInput        |Aliases                                               |
|------------|--------|--------|---------------------|------------------------------------------------------|
|`[String[]]`|false   |9       |true (ByPropertyName)|Bindings<br/>DefaultBinding<br/>DefaultBindingProperty|

#### **AmbientValue**
The ambient value
This script block can be used to coerce a value into the desired real value.

|Type           |Required|Position|PipelineInput        |Aliases    |
|---------------|--------|--------|---------------------|-----------|
|`[ScriptBlock]`|false   |10      |true (ByPropertyName)|CoerceValue|

#### **Metadata**
Any additional parameter metadata.
Any dictionaries passed to this parameter will be converted to [Reflection.AssemblyMetadata] attributes.

|Type          |Required|Position|PipelineInput        |Aliases                                 |
|--------------|--------|--------|---------------------|----------------------------------------|
|`[PSObject[]]`|false   |11      |true (ByPropertyName)|ReflectionMetadata<br/>ParameterMetadata|

#### **ValidatePattern**
The validation pattern for the parameter.

|Type          |Required|Position|PipelineInput        |Aliases          |
|--------------|--------|--------|---------------------|-----------------|
|`[PSObject[]]`|false   |12      |true (ByPropertyName)|Pattern<br/>Regex|

#### **WeaklyTyped**
If set, will make the parameter more weakly typed.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **NoMandatory**
If set, will attempt to avoid creating mandatory parameters.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.PowerShell.Parameter [[-Name] <PSObject>] [[-ParameterAttribute] <PSObject[]>] [[-Alias] <PSObject[]>] [[-Attribute] <PSObject[]>] [[-Type] <PSObject[]>] [[-DefaultValue] <PSObject>] [[-ValidateSet] <PSObject[]>] [[-Description] <PSObject[]>] [[-Binding] <String[]>] [[-AmbientValue] <ScriptBlock>] [[-Metadata] <PSObject[]>] [[-ValidatePattern] <PSObject[]>] [-WeaklyTyped] [-NoMandatory] [<CommonParameters>]
```

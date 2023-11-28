Import-ModuleMember
-------------------

### Synopsis
Imports members into a module

---

### Description

Imports members from an object into a module.

A few types of members can easily be turned into commands:
* A ScriptMethod with named blocks
* A Property with a ScriptBlock value
* A Property with a relative path
 
Each of these can easily be turned into a function or alias.

---

### Examples
> EXAMPLE 1

```PowerShell
$importedMembers = [PSCustomObject]@{
    "Did you know you PowerShell can have commands with spaces" = {
        "It's a pretty unique feature of the PowerShell language"
    }
} | Import-ModuleMember -PassThru
$importedMembers # Should -BeOfType ([Management.Automation.PSModuleInfo]) 

& "Did you know you PowerShell can have commands with spaces" # Should -BeLike '*PowerShell*'
```

---

### Parameters
#### **From**
The Source of additional module members

|Type          |Required|Position|PipelineInput |Aliases                          |
|--------------|--------|--------|--------------|---------------------------------|
|`[PSObject[]]`|false   |named   |true (ByValue)|Source<br/>Member<br/>InputObject|

#### **IncludeProperty**
If provided, will only include members that match any of these wildcards or patterns

|Type          |Required|Position|PipelineInput        |Aliases      |
|--------------|--------|--------|---------------------|-------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|IncludeMember|

#### **ExcludeProperty**
If provided, will exclude any members that match any of these wildcards or patterns

|Type          |Required|Position|PipelineInput        |Aliases      |
|--------------|--------|--------|---------------------|-------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|ExcludeMember|

#### **Module**
The module the members should be imported into.
If this is not provided, or the module has already been imported, a dynamic module will be generated.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|false   |named   |true (ByPropertyName)|

#### **PassThru**
If set, will pass thru any imported members
If a new module is created, this will pass thru the created module.
If a -Module is provided, and has not yet been imported, then the created functions and aliases will be referenced instead.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Import-ModuleMember [-From <PSObject[]>] [-IncludeProperty <PSObject[]>] [-ExcludeProperty <PSObject[]>] [-Module <Object>] [-PassThru] [<CommonParameters>]
```

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

How It Works
------------

### For Each Input

#### Convert Members to Commands
 First up, we need to take our input and turn it into something to import (we turn any dictionary into a psuedo-object, for consistency).  We need to look at each potential member and make sure it's not something we want to -Exclude.  If it is, move onto the next member If we're whitelisting as well make sure each item is in the whitelist Now what we're sure we want this member, let's see if we can have it: If it's a [ScriptBlock], it can become a function If it's a [PSScriptMethod], it can also become a function ScriptProperties can be functions, too For strings, we can see if they are a relative path to the module (assuming there is a module) If the path exists alias it.

 If we have no properties we can import, now is the time to return.

 Now we have to determine how we're declaring and importing these functions.

 We're either going to be Generating a New Module.  or Importing into a Loading Module.

 In these two scenarios we will want to generate a new module: If we did not provide a module (because how else should we import it?) or if the module has a version (because during load, a module has no version)

#### Generating a New Module
 To start off, we'll want to timestamp the module and might want to use our own invocation name to name the module.  The definition is straightforward enough, it just sets each argument with the providers and exports everything.  We pass our ImportMembers as the argument to make it all work and import the module globally.

#### Importing into a Loading Module
 If we're importing into a module that hasn't finished loading get a pointer to it's context.  and use the providers to set the item (and we're good).  If -PassThru was provided Pass thru each command.

---

### Syntax
```PowerShell
Import-ModuleMember [-From <PSObject[]>] [-IncludeProperty <PSObject[]>] [-ExcludeProperty <PSObject[]>] [-Module <Object>] [-PassThru] [<CommonParameters>]
```

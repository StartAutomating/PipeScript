Template.HTML.Command.Input
---------------------------

### Synopsis
Generates an HTML command input.

---

### Description

Generates HTML input for a command.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Command Get-Command | Template.HTML.Command.Input
```
> EXAMPLE 2

```PowerShell
Get-Command Template.HTML.Command.Input | Template.HTML.Command.Input
```

---

### Parameters
#### **CommandMetadata**
The Command Metadata.  This can be provided via the pipeline from Get-Command.

|Type               |Required|Position|PipelineInput |
|-------------------|--------|--------|--------------|
|`[CommandMetadata]`|true    |named   |true (ByValue)|

#### **Name**
The name of the command.

|Type      |Required|Position|PipelineInput        |Aliases    |
|----------|--------|--------|---------------------|-----------|
|`[String]`|false   |named   |true (ByPropertyName)|CommandName|

#### **SupportsShouldProcess**
If the command supports ShouldProcess (`-WhatIf`, `-Confirm`)

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **SupportsPaging**
If the command supports paging.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **PositionalBinding**
If the command supports positional binding

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **HelpUri**
The help URI for the command.

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |named   |true (ByPropertyName)|

#### **ConfirmImpact**
The confirm impact of the command.
Valid Values:

* None
* Low
* Medium
* High

|Type             |Required|Position|PipelineInput        |
|-----------------|--------|--------|---------------------|
|`[ConfirmImpact]`|false   |named   |true (ByPropertyName)|

#### **Parameter**
The parameter metadata for the command.

|Type        |Required|Position|PipelineInput        |Aliases   |
|------------|--------|--------|---------------------|----------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|Parameters|

#### **Description**
The Command Description.

|Type      |Required|Position|PipelineInput        |Aliases           |
|----------|--------|--------|---------------------|------------------|
|`[String]`|false   |named   |true (ByPropertyName)|CommandDescription|

#### **Synopsis**
The Command Synopsis.

|Type      |Required|Position|PipelineInput        |Aliases        |
|----------|--------|--------|---------------------|---------------|
|`[String]`|false   |named   |true (ByPropertyName)|CommandSynopsis|

#### **Example**
The Command Example.

|Type        |Required|Position|PipelineInput        |Aliases       |
|------------|--------|--------|---------------------|--------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|CommandExample|

#### **Notes**
The Command Notes.

|Type        |Required|Position|PipelineInput        |Aliases              |
|------------|--------|--------|---------------------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Note<br/>CommandNotes|

#### **Link**
The Command Links.

|Type        |Required|Position|PipelineInput        |Aliases               |
|------------|--------|--------|---------------------|----------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Links<br/>CommandLinks|

#### **ElementMap**
The Element Map.
This maps parameters to the HTML elements that will be used to render them.

|Type        |Required|Position|PipelineInput        |Aliases                        |
|------------|--------|--------|---------------------|-------------------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|ElementNameMap<br/>ElementNames|

#### **ElementAttributeMap**
The Element Attribute Map.
This maps parameters to the HTML element attributes that will be used to render them.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|

#### **ElementSeparator**
The element separator.  This is used to separate elements.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|

#### **Attribute**
The Command Attributes.  These are used to provide additional information about the command.
They will be automatically provided if piping a command into this function.
If an attribute named HTML.Input is provided, it will be returned directly.

|Type          |Required|Position|PipelineInput        |Aliases                                              |
|--------------|--------|--------|---------------------|-----------------------------------------------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|Attributes<br/>CommandAttribute<br/>CommandAttributes|

#### **ContainerElement**
The Container Element.  This is used to hold all of the elements.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **ContainerAttribute**
The Container Attributes.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|

#### **ItemElement**
The Item Element.  This is used to hold each item.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **ItemAttribute**
The Item Attributes.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|

#### **ItemSeparator**
The Item Separator.  This is used to separate items.
The default is a line break.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.HTML.Command.Input [-Name <String>] [-SupportsShouldProcess] [-SupportsPaging] [-PositionalBinding] [-HelpUri <Uri>] [-ConfirmImpact {None | Low | Medium | High}] [-Parameter <PSObject>] [-Description <String>] [-Synopsis <String>] [-Example <String[]>] [-Notes <String[]>] [-Link <String[]>] [-ElementMap <PSObject>] [-ElementAttributeMap <PSObject>] [-ElementSeparator <PSObject>] [-Attribute <PSObject[]>] [-ContainerElement <String>] [-ContainerAttribute <PSObject[]>] [-ItemElement <String>] [-ItemAttribute <PSObject[]>] [-ItemSeparator <PSObject>] [<CommonParameters>]
```
```PowerShell
Template.HTML.Command.Input -CommandMetadata <CommandMetadata> [-Name <String>] [-SupportsShouldProcess] [-SupportsPaging] [-PositionalBinding] [-HelpUri <Uri>] [-ConfirmImpact {None | Low | Medium | High}] [-Parameter <PSObject>] [-Description <String>] [-Synopsis <String>] [-Example <String[]>] [-Notes <String[]>] [-Link <String[]>] [-ElementMap <PSObject>] [-ElementAttributeMap <PSObject>] [-ElementSeparator <PSObject>] [-Attribute <PSObject[]>] [-ContainerElement <String>] [-ContainerAttribute <PSObject[]>] [-ItemElement <String>] [-ItemAttribute <PSObject[]>] [-ItemSeparator <PSObject>] [<CommonParameters>]
```

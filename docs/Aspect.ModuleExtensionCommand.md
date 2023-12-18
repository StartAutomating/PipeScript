Aspect.ModuleExtensionCommand
-----------------------------

### Synopsis
Returns a module's extended commands

---

### Description

Returns the commands or scripts in a module that match the module command pattern.

Each returned script will be decorated with the typename(s) that match,
so that the extended commands can be augmented by the extended types system.

---

### Related Links
* [Aspect.ModuleExtensionPattern](Aspect.ModuleExtensionPattern.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Aspect.ModuleExtensionCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
```

---

### Parameters
#### **Module**
The name of a module, or a module info object.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Object]`|true    |1       |true (ByPropertyName)|

#### **Commands**
A list of commands.
If this is provided, each command that is a valid extension will be returned.

|Type             |Required|Position|PipelineInput        |
|-----------------|--------|--------|---------------------|
|`[CommandInfo[]]`|false   |2       |true (ByPropertyName)|

#### **Suffix**
The suffix to apply to each named capture.
Defaults to '_Command'

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **Prefix**
The prefix to apply to each named capture.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **FilePath**
The file path(s).  If provided, will look for commands within these paths.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[Object]`|false   |5       |true (ByPropertyName)|Fullname|

#### **CommandType**
The PowerShell command type.  If this is provided, will only get commands of this type.
Valid Values:

* Alias
* Function
* Filter
* Cmdlet
* ExternalScript
* Application
* Script
* Configuration
* All

|Type            |Required|Position|PipelineInput        |
|----------------|--------|--------|---------------------|
|`[CommandTypes]`|false   |6       |true (ByPropertyName)|

#### **PSTypeName**
The base PSTypeName(s).
If provided, any commands that match the pattern will apply these typenames, too.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |7       |false        |

---

### Syntax
```PowerShell
Aspect.ModuleExtensionCommand [-Module] <Object> [[-Commands] <CommandInfo[]>] [[-Suffix] <String>] [[-Prefix] <String>] [[-FilePath] <Object>] [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [[-PSTypeName] <String[]>] [<CommonParameters>]
```

Search-Command
--------------

### Synopsis
Searches commands

---

### Description

Searches loaded commands as quickly as possible.

---

### Parameters
#### **Name**
The name of the command

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |1       |true (ByPropertyName)|Like   |

#### **Pattern**
One or more patterns to match.

|Type          |Required|Position|PipelineInput        |Aliases          |
|--------------|--------|--------|---------------------|-----------------|
|`[PSObject[]]`|false   |2       |true (ByPropertyName)|Match<br/>Matches|

#### **Module**
The module the command should be in.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |3       |true (ByPropertyName)|

#### **Verb**
The verb of the command.
This will be treated as the start of the command name (before any punctuation).

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |4       |true (ByPropertyName)|

#### **Noun**
The noun of the command
This will be treated as the end of the command name (after any punctuation).

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |5       |true (ByPropertyName)|

#### **ParameterName**
A pattern for the parameter name.
Only commands that have a parameter name or alias matching this will be returned.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |6       |true (ByPropertyName)|

#### **ParameterType**
A pattern for the parameter type.
Only commands that have a parameter type matching this will be returned.
If `-ParameterName` is also provided, it will ensure these parameters have a type that match this pattern.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |7       |true (ByPropertyName)|

#### **OutputType**
A pattern for the output type.
Only commands that have an output type matching this will be returned.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |8       |true (ByPropertyName)|

#### **InputType**
A pattern for the input type.
Only commands that have an input type matching this will be returned.
(only pipeline parameters are considered as input types)

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |9       |true (ByPropertyName)|

#### **CommandType**
The type of command to search for.
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

|Type            |Required|Position|PipelineInput        |Aliases     |
|----------------|--------|--------|---------------------|------------|
|`[CommandTypes]`|false   |10      |true (ByPropertyName)|CommandTypes|

---

### Outputs
* [Management.Automation.CommandInfo](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.CommandInfo)

---

### Notes
Get-Command is somewhat notoriously slow, and command lookup is one of the more expensive parts of PowerShell.

This command is designed to speedily search for commands by name, module, verb, noun, or pattern.

Because Search-Command is built for speed, it will _not_ autodiscover commands.

---

### Syntax
```PowerShell
Search-Command [[-Name] <String[]>] [[-Pattern] <PSObject[]>] [[-Module] <PSObject[]>] [[-Verb] <String[]>] [[-Noun] <String[]>] [[-ParameterName] <String[]>] [[-ParameterType] <PSObject[]>] [[-OutputType] <PSObject[]>] [[-InputType] <PSObject[]>] [[-CommandType] {Alias | Function | Filter | Cmdlet | ExternalScript | Application | Script | Configuration | All}] [<CommonParameters>]
```

Get-Transpiler
--------------

### Synopsis
Gets Extensions

---

### Description

Gets Extensions.

Transpiler can be found in:

* Any module that includes -TranspilerModuleName in it's tags.
* The directory specified in -TranspilerPath
* Commands that meet the naming criteria

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Transpiler
```

---

### Parameters
#### **TranspilerPath**
If provided, will look beneath a specific path for extensions.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |1       |true (ByPropertyName)|Fullname|

#### **Force**
If set, will clear caches of extensions, forcing a refresh.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **CommandName**
If provided, will get Transpiler that extend a given command

|Type        |Required|Position|PipelineInput        |Aliases            |
|------------|--------|--------|---------------------|-------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|ThatExtends<br/>For|

#### **TranspilerName**
The name of an extension.
By default, this will match any extension command whose name, displayname, or aliases exactly match the name.
If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|

#### **Like**
If provided, will treat -TranspilerName as a wildcard.
This will return any extension whose name, displayname, or aliases are like the -TranspilerName.
If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Match**
If provided, will treat -TranspilerName as a regular expression.
This will return any extension whose name, displayname, or aliases match the -TranspilerName.
If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **DynamicParameter**
If set, will return the dynamic parameters object of all the Transpiler for a given command.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **CouldRun**
If set, will return if the extension could run.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[Switch]`|false   |named   |true (ByPropertyName)|CanRun |

#### **CouldPipe**
If set, will return if the extension could accept this input from the pipeline.

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[PSObject]`|false   |4       |false        |CanPipe|

#### **Run**
If set, will run the extension.  If -Stream is passed, results will be directly returned.
By default, extension results are wrapped in a return object.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Stream**
If set, will stream output from running the extension.
By default, extension results are wrapped in a return object.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **DynamicParameterSetName**
If set, will return the dynamic parameters of all Transpiler for a given command, using the provided DynamicParameterSetName.
Implies -DynamicParameter.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

#### **DynamicParameterPositionOffset**
If provided, will return the dynamic parameters of all Transpiler for a given command, with all positional parameters offset.
Implies -DynamicParameter.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |6       |true (ByPropertyName)|

#### **NoMandatoryDynamicParameter**
If set, will return the dynamic parameters of all Transpiler for a given command, with all mandatory parameters marked as optional.
Implies -DynamicParameter.  Does not actually prevent the parameter from being Mandatory on the Extension.

|Type      |Required|Position|PipelineInput        |Aliases                     |
|----------|--------|--------|---------------------|----------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|NoMandatoryDynamicParameters|

#### **RequireTranspilerAttribute**
If set, will require a [Runtime.CompilerServices.Extension()] attribute to be considered an extension.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ValidateInput**
If set, will validate this input against [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |7       |true (ByPropertyName)|

#### **AllValid**
If set, will validate this input against all [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.
By default, if any validation attribute returned true, the extension is considered validated.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **ParameterSetName**
The name of the parameter set.  This is used by -CouldRun and -Run to enforce a single specific parameter set.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |8       |true (ByPropertyName)|

#### **Parameter**
The parameters to the extension.  Only used when determining if the extension -CouldRun.

|Type           |Required|Position|PipelineInput        |Aliases                                                  |
|---------------|--------|--------|---------------------|---------------------------------------------------------|
|`[IDictionary]`|false   |9       |true (ByPropertyName)|Parameters<br/>ExtensionParameter<br/>ExtensionParameters|

#### **SteppablePipeline**
If set, will output a steppable pipeline for the extension.
Steppable pipelines allow you to control how begin, process, and end are executed in an extension.
This allows for the execution of more than one extension at a time.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Help**
If set, will output the help for the extensions

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Outputs
* Extension

---

### Syntax
```PowerShell
Get-Transpiler [[-TranspilerPath] <String>] [-Force] [[-CommandName] <String[]>] [[-TranspilerName] <String[]>] [-Like] [-Match] [-DynamicParameter] [-CouldRun] [[-CouldPipe] <PSObject>] [-Run] [-Stream] [[-DynamicParameterSetName] <String>] [[-DynamicParameterPositionOffset] <Int32>] [-NoMandatoryDynamicParameter] [-RequireTranspilerAttribute] [[-ValidateInput] <PSObject>] [-AllValid] [[-ParameterSetName] <String>] [[-Parameter] <IDictionary>] [-SteppablePipeline] [-Help] [<CommonParameters>]
```

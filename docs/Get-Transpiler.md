
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

---
### Examples
#### EXAMPLE 1
```PowerShell
Get-Transpiler
```

---
### Parameters
#### **TranspilerPath**

If provided, will look beneath a specific path for extensions.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will clear caches of extensions, forcing a refresh.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **CommandName**

If provided, will get Transpiler that extend a given command



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **TranspilerName**

The name of an extension.
By default, this will match any extension command whose name, displayname, or aliases exactly match the name.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Like**

If provided, will treat -TranspilerName as a wildcard.
This will return any extension whose name, displayname, or aliases are like the -TranspilerName.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Match**

If provided, will treat -TranspilerName as a regular expression.
This will return any extension whose name, displayname, or aliases match the -TranspilerName.

If the extension has an Alias with a regular expression literal (```'/Expression/'```) then the -TranspilerName will be valid if that regular expression matches.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DynamicParameter**

If set, will return the dynamic parameters object of all the Transpiler for a given command.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **CouldRun**

If set, will return if the extension could run.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **CouldPipe**

If set, will return if the extension could accept this input from the pipeline.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:false



---
#### **Run**

If set, will run the extension.  If -Stream is passed, results will be directly returned.
By default, extension results are wrapped in a return object.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Stream**

If set, will stream output from running the extension.
By default, extension results are wrapped in a return object.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DynamicParameterSetName**

If set, will return the dynamic parameters of all Transpiler for a given command, using the provided DynamicParameterSetName.
Implies -DynamicParameter.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **DynamicParameterPositionOffset**

If provided, will return the dynamic parameters of all Transpiler for a given command, with all positional parameters offset.
Implies -DynamicParameter.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **NoMandatoryDynamicParameter**

If set, will return the dynamic parameters of all Transpiler for a given command, with all mandatory parameters marked as optional.
Implies -DynamicParameter.  Does not actually prevent the parameter from being Mandatory on the Extension.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **RequireTranspilerAttribute**

If set, will require a [Runtime.CompilerServices.Extension()] attribute to be considered an extension.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ValidateInput**

If set, will validate this input against [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **AllValid**

If set, will validate this input against all [ValidateScript], [ValidatePattern], [ValidateSet], and [ValidateRange] attributes found on an extension.
By default, if any validation attribute returned true, the extension is considered validated.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ParameterSetName**

The name of the parameter set.  This is used by -CouldRun and -Run to enforce a single specific parameter set.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **Parameter**

The parameters to the extension.  Only used when determining if the extension -CouldRun.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **SteppablePipeline**

If set, will output a steppable pipeline for the extension.
Steppable pipelines allow you to control how begin, process, and end are executed in an extension.
This allows for the execution of more than one extension at a time.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Help**

If set, will output the help for the extensions



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* Extension




---
### Syntax
```PowerShell
Get-Transpiler [[-TranspilerPath] <String>] [-Force] [[-CommandName] <String[]>] [[-TranspilerName] <String[]>] [-Like] [-Match] [-DynamicParameter] [-CouldRun] [[-CouldPipe] <PSObject>] [-Run] [-Stream] [[-DynamicParameterSetName] <String>] [[-DynamicParameterPositionOffset] <Int32>] [-NoMandatoryDynamicParameter] [-RequireTranspilerAttribute] [[-ValidateInput] <PSObject>] [-AllValid] [[-ParameterSetName] <String>] [[-Parameter] <IDictionary>] [-SteppablePipeline] [-Help] [<CommonParameters>]
```
---



Get-PipeScript
--------------




### Synopsis
Gets PipeScript.



---


### Description

Gets PipeScript and it's extended commands.
Because 'Get' is the default verb in PowerShell,
Get-PipeScript also allows you to run other commands in noun-oriented syntax.



---


### Examples
#### EXAMPLE 1
```PowerShell
Get-PipeScript
```

#### EXAMPLE 2
```PowerShell
Get-PipeScript -PipeScriptType Transpiler
```

#### EXAMPLE 3
```PowerShell
Get-PipeScript -PipeScriptType Template -PipeScriptPath Template
```

#### EXAMPLE 4
```PowerShell
PipeScript Invoke { "hello world"}
```

#### EXAMPLE 5
```PowerShell
{ partial function f { } }  | PipeScript Import -PassThru
```



---


### Parameters
#### **PipeScriptPath**

The path containing pipescript files.
If this parameter is provided, only PipeScripts in this path will be outputted.






|Type      |Required|Position|PipelineInput        |Aliases                         |
|----------|--------|--------|---------------------|--------------------------------|
|`[String]`|false   |named   |true (ByPropertyName)|Fullname<br/>FilePath<br/>Source|



#### **PipeScriptType**

One or more PipeScript Command Types.



Valid Values:

* AutomaticVariable
* PreProcessor
* PostProcessor
* Interface
* Sentence
* BuildScript
* Protocol
* Aspect
* PipeScriptNoun
* Partial
* Transpiler
* Analyzers
* Template
* Optimizer






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|



#### **Argument**

Any positional arguments that are not directly bound.
This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Object]`|false   |named   |false        |Args   |



#### **InputObject**

The InputObject.
This parameter primarily exists to allow Get-PipeScript to pass it down to other commands.






|Type      |Required|Position|PipelineInput |Aliases     |
|----------|--------|--------|--------------|------------|
|`[Object]`|false   |named   |true (ByValue)|Input<br/>In|



#### **Force**

If set, will force a refresh of the loaded Pipescripts.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Get-PipeScript [-PipeScriptPath <String>] [-PipeScriptType <String[]>] [-Argument <Object>] [-InputObject <Object>] [-Force] [<CommonParameters>]
```

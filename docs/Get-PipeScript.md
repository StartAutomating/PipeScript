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
Get every specialized PipeScript command

```PowerShell
Get-PipeScript
```
Get all transpilers

```PowerShell
Get-PipeScript -PipeScriptType Transpiler
```
Get all template files within the current directory.

```PowerShell
Get-PipeScript -PipeScriptType Template -PipeScriptPath $pwd
```
You can use `noun verb` to call any core PipeScript command.

```PowerShell
PipeScript Invoke { "hello world" } # Should -Be 'Hello World'
```
You can still use the object pipeline with `noun verb`

```PowerShell
{ partial function f { } }  |
    PipeScript Import -PassThru # Should -BeOfType ([Management.Automation.PSModuleInfo])
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

* Analyzer
* Aspect
* AutomaticVariable
* BuildScript
* Compiler
* ContentType
* Interface
* Language
* Optimizer
* Parser
* Partial
* PipeScriptNoun
* PostProcessor
* PreProcessor
* Protocol
* Route
* Sentence
* Service
* Template
* Transform
* Transpiler

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

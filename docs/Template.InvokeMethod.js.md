Template.InvokeMethod.js
------------------------

### Synopsis
Template for a JavaScript method invocation

---

### Description

Template for invocing a method in JavaScript.

---

### Examples
> EXAMPLE 1

doSomethingElse(result)"
> EXAMPLE 2

doSomethingElse(result)"

---

### Parameters
#### **Name**
The name of the method.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **InputObject**
The input object (this allows piping this to become chaining methods)

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |2       |true (ByValue)|

#### **Argument**
The arguments to the method

|Type        |Required|Position|PipelineInput        |Aliases                               |
|------------|--------|--------|---------------------|--------------------------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|Arguments<br/>Parameter<br/>Parameters|

#### **Await**
If set, the method return will be awaited (this will only work in an async function)

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Template.InvokeMethod.js [[-Name] <String>] [[-InputObject] <PSObject>] [[-Argument] <String[]>] [-Await] [<CommonParameters>]
```

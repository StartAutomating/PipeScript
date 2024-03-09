Template.ForeachArgument.js
---------------------------

### Synopsis
JavaScript Foreach Argument Template

---

### Description

A Template for a script that walks over each argument, in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.ForeachArgument.js | Set-Content .\Args.js
Invoke-PipeScript -Path .\Args.js -Arguments "a",@{"b"='c'}
```

---

### Parameters
#### **Statement**
One or more statements
By default this is `print(sys.argv[i])`

|Type        |Required|Position|PipelineInput        |Aliases                                       |
|------------|--------|--------|---------------------|----------------------------------------------|
|`[String[]]`|false   |1       |true (ByPropertyName)|Body<br/>Code<br/>Block<br/>Script<br/>Scripts|

#### **Before**
One or more statements to run before the loop.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|

#### **After**
The statement to run after the loop.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |3       |true (ByPropertyName)|

#### **ArgumentSource**
The source of the arguments.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **Variable**
The current argument variable.
This initializes the loop.

|Type      |Required|Position|PipelineInput        |Aliases                             |
|----------|--------|--------|---------------------|------------------------------------|
|`[String]`|false   |5       |true (ByPropertyName)|CurrentArgument<br/>ArgumentVariable|

#### **Condition**
The argument collection.
This is what is looped thru.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **Indent**
The number of characters to indent.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |7       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.ForeachArgument.js [[-Statement] <String[]>] [[-Before] <String[]>] [[-After] <String[]>] [[-ArgumentSource] <String>] [[-Variable] <String>] [[-Condition] <String>] [[-Indent] <Int32>] [<CommonParameters>]
```

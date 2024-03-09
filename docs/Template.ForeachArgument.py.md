Template.ForeachArgument.py
---------------------------

### Synopsis
Python Foreach Argument Template

---

### Description

A Template that walks over each argument, in Python.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.ForeachArgument.py | Set-Content .\Args.py
Invoke-PipeScript -Path .\Args.py -Arguments "a",@{"b"='c'}
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
By default this is `import sys`.

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
By default this is `for i in range(1, len(sys.argv)):`

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **Indent**
The number of characters to indent.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |5       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.ForeachArgument.py [[-Statement] <String[]>] [[-Before] <String[]>] [[-After] <String[]>] [[-ArgumentSource] <String>] [[-Indent] <Int32>] [<CommonParameters>]
```

Template.Include.cpp
--------------------

### Synopsis
C++ Include Template

---

### Description

Template for Include statements in C++

---

### Parameters
#### **LibraryName**
The name of one or more libraries to import

|Type        |Required|Position|PipelineInput        |Aliases                   |
|------------|--------|--------|---------------------|--------------------------|
|`[String[]]`|false   |1       |true (ByPropertyName)|ModuleName<br/>PackageName|

#### **IsSystemHeader**
If the library is a system header, it will be included with `<>`.
This is also known as a `-StandardLibrary`, and is also aliased to `-Global`.

|Type      |Required|Position|PipelineInput|Aliases                   |
|----------|--------|--------|-------------|--------------------------|
|`[Switch]`|false   |named   |false        |Global<br/>StandardLibrary|

---

### Syntax
```PowerShell
Template.Include.cpp [[-LibraryName] <String[]>] [-IsSystemHeader] [<CommonParameters>]
```

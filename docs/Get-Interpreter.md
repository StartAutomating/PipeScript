Get-Interpreter
---------------

### Synopsis
Gets Interpreters

---

### Description

Gets PipeScript Interpreters

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Interpreter
```
> EXAMPLE 2

```PowerShell
Get-Interpreter -LanguageName "JavaScript"
```

---

### Parameters
#### **LanguageName**
The name of one or more languages.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|

#### **ArgumentList**
Any remaining arguments.

|Type          |Required|Position|PipelineInput|Aliases                       |
|--------------|--------|--------|-------------|------------------------------|
|`[PSObject[]]`|false   |named   |false        |Args<br/>Arguments<br/>ArgList|

#### **InputObject**
Any input object.

|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |named   |true (ByValue)|

---

### Notes
This command accepts open-ended input.

---

### Syntax
```PowerShell
Get-Interpreter [-LanguageName <String[]>] [-ArgumentList <PSObject[]>] [-InputObject <PSObject>] [<CommonParameters>]
```

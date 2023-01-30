Bash.Template
-------------
### Synopsis
Bash Template Transpiler.

---
### Description

Allows PipeScript to generate Bash scripts.

Heredocs named PipeScript{} will be treated as blocks of PipeScript.

```bash
<<PipeScript{}

# This will be considered PipeScript / PowerShell, and will return the contents of a bash script.

PipeScript{}
```

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $bashScript = @'
    echo 'hello world'
```
<<PipeScript{}
        "echo '$('hi','yo','sup' | Get-Random)'"
    PipeScript{}
'@

    [OutputFile('.\HelloWorld.ps1.sh')]$bashScript
}

Invoke-PipeScript .\HelloWorld.ps1.sh
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |



---
#### **Parameter**

A dictionary of parameters.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



---
#### **ArgumentList**

A list of arguments.






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |



---
### Syntax
```PowerShell
Bash.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Bash.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---


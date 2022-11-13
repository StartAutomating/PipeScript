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



> **Type**: ```[CommandInfo]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:false



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Bash.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Bash.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
---


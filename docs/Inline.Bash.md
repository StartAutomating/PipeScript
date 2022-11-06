Inline.Bash
-----------
### Synopsis
Bash PipeScript Transpiler.

---
### Description

Transpiles Bash with Inline PipeScript into Bash.

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

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **Parameter**

A dictionary of parameters.



> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **ArgumentList**

A list of arguments.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Inline.Bash [-CommandInfo] <CommandInfo> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---


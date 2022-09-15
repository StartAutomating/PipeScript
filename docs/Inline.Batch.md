
Inline.Batch
------------
### Synopsis
Batch PipeScript Transpiler.

---
### Description

Transpiles Windows Batch with Inline PipeScript into Batch Scripts.

Because Batch Scripts only allow single-line comments, this is done using a pair of comment markers.
        

```batch    
:: {

Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = 'hello world')
:: "echo $message"

:: }
```

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    $batchScript = &#39;    
:: {
```
Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = "hello world")
:: "echo $message"

:: }
'

    [OutputFile('.\HelloWorld.ps1.cmd')]$batchScript
}

Invoke-PipeScript .\HelloWorld.ps1.cmd
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
Inline.Batch [-CommandInfo] &lt;CommandInfo&gt; [[-Parameter] &lt;IDictionary&gt;] [[-ArgumentList] &lt;PSObject[]&gt;] [&lt;CommonParameters&gt;]
```
---




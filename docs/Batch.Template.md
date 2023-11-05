Batch.Template
--------------




### Synopsis
Batch Template Transpiler.



---


### Description

Allows PipeScript to generate Windows Batch Scripts.

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
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $batchScript = '    
:: {
Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = "hello world")
:: "echo $message"

:: }
'

    [OutputFile('.\HelloWorld.ps1.cmd')]$batchScript
}

Invoke-PipeScript .\HelloWorld.ps1.cmd
```


---


### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[CommandInfo]`|true    |named   |true (ByValue)|



#### **AsTemplateObject**

If set, will return the information required to dynamically apply this template to any text.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|true    |named   |false        |



#### **Parameter**

A dictionary of parameters.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |



#### **ArgumentList**

A list of arguments.






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |





---


### Syntax
```PowerShell
Batch.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Batch.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

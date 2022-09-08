
OutputFile
----------
### Synopsis
Outputs to a File

---
### Description

Outputs the result of a script into a file.

---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-PipeScript {
    [OutputFile("hello.txt")]
    param()
```
'hello world'
}
#### EXAMPLE 2
```PowerShell
Invoke-PipeScript {
    param()
```
$Message = 'hello world'
    [Save(".\Hello.txt")]$Message
}
---
### Parameters
#### **OutputPath**

The Output Path



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|true    |1      |false        |
---
#### **ScriptBlock**

The Script Block that will be run.



|Type               |Requried|Postion|PipelineInput |
|-------------------|--------|-------|--------------|
|```[ScriptBlock]```|false   |2      |true (ByValue)|
---
#### **VariableAst**

|Type                         |Requried|Postion|PipelineInput |
|-----------------------------|--------|-------|--------------|
|```[VariableExpressionAst]```|false   |3      |true (ByValue)|
---
#### **Encoding**

The encoding parameter.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[String]```|false   |4      |false        |
---
#### **Force**

If set, will force output, overwriting existing files.



|Type          |Requried|Postion|PipelineInput|
|--------------|--------|-------|-------------|
|```[Switch]```|false   |named  |false        |
---
#### **ExportScript**

The export script



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[ScriptBlock]```|false   |5      |false        |
---
#### **Depth**

The serialization depth.  Currently only used when saving to JSON files.



|Type         |Requried|Postion|PipelineInput|
|-------------|--------|-------|-------------|
|```[Int32]```|false   |6      |false        |
---
### Syntax
```PowerShell
OutputFile [-OutputPath] <String> [[-ScriptBlock] <ScriptBlock>] [[-VariableAst] <VariableExpressionAst>] [[-Encoding] <String>] [-Force] [[-ExportScript] <ScriptBlock>] [[-Depth] <Int32>] [<CommonParameters>]
```
---




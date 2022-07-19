
New-PipeScript
--------------
### Synopsis
Creates new PipeScript.

---
### Description

Creates new PipeScript and PowerShell ScriptBlocks.

---
### Examples
#### EXAMPLE 1
```PowerShell
New-PipeScript -Parameter @{a='b'}
```

---
### Parameters
#### **Parameter**

Defines one or more parameters for a ScriptBlock.
Parameters can be defined in a few ways:
* As a ```[Collections.Dictionary]``` of Parameters
* As the ```[string]``` name of an untyped parameter.    
* As a ```[ScriptBlock]``` containing only parameters.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[Object]```|false   |1      |true (ByPropertyName)|
---
#### **DynamicParameter**

The dynamic parameter block.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[ScriptBlock]```|false   |2      |true (ByPropertyName)|
---
#### **Begin**

The begin block.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[ScriptBlock]```|false   |3      |true (ByPropertyName)|
---
#### **Process**

The process block.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[ScriptBlock]```|false   |4      |true (ByPropertyName)|
---
#### **End**

The end block.



|Type               |Requried|Postion|PipelineInput        |
|-------------------|--------|-------|---------------------|
|```[ScriptBlock]```|false   |5      |true (ByPropertyName)|
---
#### **Header**

The script header.



|Type          |Requried|Postion|PipelineInput        |
|--------------|--------|-------|---------------------|
|```[String]```|false   |6      |true (ByPropertyName)|
---
### Syntax
```PowerShell
New-PipeScript [[-Parameter] <Object>] [[-DynamicParameter] <ScriptBlock>] [[-Begin] <ScriptBlock>] [[-Process] <ScriptBlock>] [[-End] <ScriptBlock>] [[-Header] <String>] [<CommonParameters>]
```
---



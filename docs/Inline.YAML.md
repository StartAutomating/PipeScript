
Inline.YAML
-----------
### Synopsis
Yaml File Transpiler.

---
### Description

Transpiles Yaml with Inline PipeScript into Yaml.

Because Yaml does not support comment blocks, PipeScript can be written inline inside of specialized Yaml string.

PipeScript can be included in a multiline Yaml string with the Key PipeScript and a Value surrounded by {}

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    $yamlContent = @'
PipeScript: |
{
@{a='b'}
}
```
List:
- PipeScript: |
  {
    @{a='b';k2='v';k3=@{k='v'}}
  }
- PipeScript: |
  {
    @(@{a='b'}, @{c='d'})
  }      
- PipeScript: |
  {
    @{a='b'}, @{c='d'}
  }
'@
    [OutputFile('.\HelloWorld.ps1.yaml')]$yamlContent
}

.> .\HelloWorld.ps1.yaml
---
### Parameters
#### **CommandInfo**

The command information.  This will include the path to the file.



|Type          |Requried|Postion|PipelineInput |
|--------------|--------|-------|--------------|
|```[Object]```|true    |1      |true (ByValue)|
---
#### **Parameter**

A dictionary of parameters.



|Type               |Requried|Postion|PipelineInput|
|-------------------|--------|-------|-------------|
|```[IDictionary]```|false   |2      |false        |
---
#### **ArgumentList**

A list of arguments.



|Type              |Requried|Postion|PipelineInput|
|------------------|--------|-------|-------------|
|```[PSObject[]]```|false   |3      |false        |
---
### Syntax
```PowerShell
Inline.YAML [-CommandInfo] <Object> [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [<CommonParameters>]
```
---



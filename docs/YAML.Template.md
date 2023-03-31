YAML.Template
-------------




### Synopsis
Yaml Template Transpiler.



---


### Description

Allows PipeScript to generate Yaml.

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
YAML.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
YAML.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

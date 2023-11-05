SVG.template
------------




### Synopsis
SVG Template Transpiler.



---


### Description

Allows PipeScript to generate SVG.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.



---


### Examples
> EXAMPLE 1

```PowerShell
$starsTemplate = Invoke-PipeScript {
    Stars.svg template '
        <!--{
            Invoke-RestMethod https://pssvg.start-automating.com/Examples/Stars.svg
        }-->
    '
}
$starsTemplate.Save("$pwd\Stars.svg")
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
SVG.template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
SVG.template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

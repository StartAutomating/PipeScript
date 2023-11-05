PS1XML.Template
---------------




### Synopsis
PS1XML Template Transpiler.



---


### Description

Allows PipeScript to generate PS1XML.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.



---


### Examples
> EXAMPLE 1

```PowerShell
$typesFile, $typeDefinition, $scriptMethod = Invoke-PipeScript {
types.ps1xml template '
    <Types>
        <!--{param([Alias("TypeDefinition")]$TypeDefinitions) $TypeDefinitions }-->
    </Types>
    '

    typeDefinition.ps1xml template '
    <Type>
        <!--{param([Alias("PSTypeName")]$TypeName) "<Name>$($typename)</Name>" }-->
        <!--{param([Alias("PSMembers","Member")]$Members) "<Members>$($members)</Members>" }-->
    </Type>
    '

    scriptMethod.ps1xml template '
    <ScriptMethod>
        <!--{param([Alias("Name")]$MethodName) "<Name>$($MethodName)</Name>" }-->
        <!--{param([ScriptBlock]$MethodDefinition) "<Script>$([Security.SecurityElement]::Escape("$MethodDefinition"))</Script>" }-->
    </ScriptMethod>
    '
}


$typesFile.Save("Test.types.ps1xml",
    $typeDefinition.Evaluate(@{
        TypeName='foobar'
        Members = 
            @($scriptMethod.Evaluate(
                @{
                    MethodName = 'foo'
                    MethodDefinition = {"foo"}
                }
            ),$scriptMethod.Evaluate(
                @{
                    MethodName = 'bar'
                    MethodDefinition = {"bar"}
                }
            ),$scriptMethod.Evaluate(
                @{
                    MethodName = 'baz'
                    MethodDefinition = {"baz"}
                }
            ))
    })
)
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
PS1XML.Template -CommandInfo <CommandInfo> [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
PS1XML.Template -AsTemplateObject [-Parameter <IDictionary>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

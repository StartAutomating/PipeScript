New-PipeScript
--------------

### Synopsis
Creates new PipeScript.

---

### Description

Creates new PipeScript and PowerShell ScriptBlocks.

This allow you to create scripts dynamically.

---

### Examples
Without any parameters, this will make an empty script block

```PowerShell
New-PipeScript # Should -BeOfType([ScriptBlock])
```
We can use -AutoParameter to automatically populate parameters:

```PowerShell
New-PipeScript -ScriptBlock { $x + $y} -AutoParameter
```
We can use -AutoParameter and -AutoParameterType to automatically make all parameters a specific type:

```PowerShell
New-PipeScript -ScriptBlock { $x, $y } -AutoParameter -AutoParameterType double
```
We can provide a -FunctionName to make a function.
New-PipeScript transpiles the scripts it generates, so this will also declare the function.

```PowerShell
New-PipeScript -ScriptBlock { Get-Random -Min 1 -Max 20 } -FunctionName ANumberBetweenOneAndTwenty
ANumberBetweenOneAndTwenty # Should -BeLessThan 21
```
We can provide parameters as a dictionary.                

```PowerShell
New-PipeScript -Parameter @{"foo"=@{
    Name = "foo"
    Help = 'Foobar'
    Attributes = "Mandatory","ValueFromPipelineByPropertyName"
    Aliases = "fubar"
    Type = "string"
}}
```
We can provide parameters from .NET reflection.
We can provide additional parameter help with -ParameterHelp

```PowerShell
New-PipeScript -Parameter ([Net.HttpWebRequest].GetProperties()) -ParameterHelp @{
    Accept='
HTTP Accept.
HTTP Accept indicates what content types the web request will accept as a response.
'
}
```
If a .NET type has XML Documentation, this can generate parameter help.

```PowerShell
New-PipeScript -FunctionName New-TableControl -Parameter (
    [Management.Automation.TableControl].GetProperties()
) -Process {
    New-Object Management.Automation.TableControl -Property $psBoundParameters
} -Synopsis 'Creates a table control'
Get-Help New-TableControl -Parameter *
```
> EXAMPLE 8

```PowerShell
$CreatedCommands = 
    [Management.Automation.TableControl],
        [Management.Automation.TableControlColumnHeader],
        [Management.Automation.TableControlRow],
        [Management.Automation.TableControlColumn],
        [Management.Automation.DisplayEntry] |
            New-PipeScript -Noun { $_.Name } -Verb New -Alias {
                "Get-$($_.Name)", "Set-$($_.Name)"
            } -Synopsis {
                "Creates, Changes, or Gets $($_.Name)"
            }
New-TableControl -Headers @(
    New-TableControlColumnHeader -Label "First" -Alignment Left -Width 10
    New-TableControlColumnHeader -Label "Second" -Alignment Center -Width 20
    New-TableControlColumnHeader -Label "Third" -Alignment Right -Width 20
) -Rows @(
    New-TableControlRow -Columns @(
        New-TableControlColumn -DisplayEntry (
            New-DisplayEntry First Property
        )
        New-TableControlColumn -DisplayEntry (
            New-DisplayEntry Second Property
        )
        New-TableControlColumn -DisplayEntry (
            New-DisplayEntry Third Property
        )
    )
)
```

---

### Parameters
#### **InputObject**
An input object.  
This can be anything, and in a few special cases, this can become the script.
If the InputObject is a `[ScriptBlock]`, this will be treated as if it was the -Process parameter.
If the InputObject is a `[Type]`, this will create a script to work with that type.

|Type      |Required|Position|PipelineInput |
|----------|--------|--------|--------------|
|`[Object]`|false   |named   |true (ByValue)|

#### **Parameter**
Defines one or more parameters for a ScriptBlock.
Parameters can be defined in a few ways:
* As a ```[Collections.Dictionary]``` of Parameters
* As the ```[string]``` name of an untyped parameter.
* As a ```[ScriptBlock]``` containing only parameters.

|Type      |Required|Position|PipelineInput        |Aliases                               |
|----------|--------|--------|---------------------|--------------------------------------|
|`[Object]`|false   |named   |true (ByPropertyName)|Parameters<br/>Property<br/>Properties|

#### **OutputPath**
If provided, will output to this path instead of returning a new script block.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **DynamicParameter**
The dynamic parameter block.

|Type           |Required|Position|PipelineInput        |Aliases              |
|---------------|--------|--------|---------------------|---------------------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|DynamicParameterBlock|

#### **Begin**
The begin block.

|Type           |Required|Position|PipelineInput        |Aliases   |
|---------------|--------|--------|---------------------|----------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|BeginBlock|

#### **Process**
The process block.
If a [ScriptBlock] is piped in and this has not been provided,
-Process will be mapped to that script.

|Type           |Required|Position|PipelineInput        |Aliases                     |
|---------------|--------|--------|---------------------|----------------------------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|ProcessBlock<br/>ScriptBlock|

#### **End**
The end block.

|Type           |Required|Position|PipelineInput        |Aliases |
|---------------|--------|--------|---------------------|--------|
|`[ScriptBlock]`|false   |named   |true (ByPropertyName)|EndBlock|

#### **Header**
The script header.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **AutoParameter**
If provided, will automatically create parameters.
Parameters will be automatically created for any unassigned variables.

|Type      |Required|Position|PipelineInput        |Aliases                            |
|----------|--------|--------|---------------------|-----------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|AutoParameterize<br/>AutoParameters|

#### **AutoParameterType**
The type used for automatically generated parameters.
By default, ```[PSObject]```.

|Type    |Required|Position|PipelineInput        |
|--------|--------|--------|---------------------|
|`[Type]`|false   |named   |true (ByPropertyName)|

#### **ParameterHelp**
If provided, will add inline help to parameters.

|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|false   |named   |true (ByPropertyName)|

#### **WeaklyTyped**
If set, will weakly type parameters generated by reflection.
1. Any parameter type implements IList should be made a [PSObject[]]
2. Any parameter that implements IDictionary should be made an [Collections.IDictionary]
3. Booleans should be made into [switch]es
4. All other parameter types should be [PSObject]

|Type      |Required|Position|PipelineInput        |Aliases                                                                                           |
|----------|--------|--------|---------------------|--------------------------------------------------------------------------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|WeakType<br/>WeakParameters<br/>WeaklyTypedParameters<br/>WeakProperties<br/>WeaklyTypedProperties|

#### **FunctionName**
The name of the function to create.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Verb**
The verb of the function to create.  This implies a -FunctionName.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Noun**
The noun of the function to create.  This implies a -FunctionName.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FunctionType**
The type or namespace the function to create.  This will be ignored if -FunctionName is not passed.
If the function type is not function or filter, it will be treated as a function namespace.

|Type      |Required|Position|PipelineInput|Aliases                               |
|----------|--------|--------|-------------|--------------------------------------|
|`[String]`|false   |named   |false        |FunctionNamespace<br/>CommandNamespace|

#### **Description**
A description of the script's functionality.  If provided with -Synopsis, will generate help.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Synopsis**
A short synopsis of the script's functionality.  If provided with -Description, will generate help.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|Summary|

#### **Example**
A list of examples to use in help.  Will be ignored if -Synopsis and -Description are not passed.

|Type        |Required|Position|PipelineInput|Aliases |
|------------|--------|--------|-------------|--------|
|`[String[]]`|false   |named   |false        |Examples|

#### **Link**
A list of links to use in help.  Will be ignored if -Synopsis and -Description are not passed.

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[String[]]`|false   |named   |false        |Links  |

#### **Attribute**
A list of attributes to declare on the scriptblock.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **Alias**
A list of potential aliases for the command.

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |named   |true (ByPropertyName)|Aliases|

#### **NoMandatory**
If set, will try not to create mandatory parameters.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **NoTranspile**
If set, will not transpile the created code.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **ReferenceObject**
A Reference Object.
This can be used for properties that are provided from a JSON Schema or OpenAPI definition or some similar structure.
It will take a slash based path to a component or property and use that as it's value.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

---

### Syntax
```PowerShell
New-PipeScript [-InputObject <Object>] [-Parameter <Object>] [-OutputPath <String>] [-DynamicParameter <ScriptBlock>] [-Begin <ScriptBlock>] [-Process <ScriptBlock>] [-End <ScriptBlock>] [-Header <String>] [-AutoParameter] [-AutoParameterType <Type>] [-ParameterHelp <IDictionary>] [-WeaklyTyped] [-FunctionName <String>] [-Verb <String>] [-Noun <String>] [-FunctionType <String>] [-Description <String>] [-Synopsis <String>] [-Example <String[]>] [-Link <String[]>] [-Attribute <String[]>] [-Alias <String[]>] [-NoMandatory] [-NoTranspile] [-ReferenceObject <Object>] [<CommonParameters>]
```

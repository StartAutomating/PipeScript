Template.PipeScript.Inherit
---------------------------

### Synopsis
Inherits a Command

---

### Description

Inherits a given command.  

This acts similarily to inheritance in Object Oriented programming.

By default, inheriting a function will join the contents of that function with the -ScriptBlock.

Your ScriptBlock will come first, so you can override any of the behavior of the underlying command.    

You can "abstractly" inherit a command, that is, inherit only the command's parameters.

Inheritance can also be -Abstract.

When you use Abstract inheritance, you get only the function definition and header from the inherited command.

You can also -Override the command you are inheriting.

This will add an [Alias()] attribute containing the original command name.

One interesting example is overriding an application

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    [inherit("Get-Command")]
    param()
}
```
> EXAMPLE 2

```PowerShell
{
    [inherit("gh",Overload)]
    param()
    begin { "ABOUT TO CALL GH"}
    end { "JUST CALLED GH" }
}.Transpile()
```
Inherit Get-Transpiler abstractly and make it output the parameters passed in.

```PowerShell
{
    [inherit("Get-Transpiler", Abstract)]
    param() process { $psBoundParameters }
}.Transpile()
```
> EXAMPLE 4

```PowerShell
{
    [inherit("Get-Transpiler", Dynamic, Abstract)]
    param()
} | .>PipeScript
```

---

### Parameters
#### **Command**
The command that will be inherited.

|Type      |Required|Position|PipelineInput|Aliases    |
|----------|--------|--------|-------------|-----------|
|`[String]`|true    |1       |false        |CommandName|

#### **Abstract**
If provided, will abstractly inherit a function.
This include the function's parameters, but not it's content
It will also define a variable within a dynamicParam {} block that contains the base command.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Override**
If provided, will set an alias on the function to replace the original command.

|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|false   |named   |false        |Overload|

#### **Dynamic**
If set, will dynamic overload commands.
This will use dynamic parameters instead of static parameters, and will use a proxy command to invoke the inherited command.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **NoDynamic**
If set, will not generate a dynamic parameter block.  This is primarily present so Abstract inheritance has a small change footprint.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Proxy**
If set, will always inherit commands as proxy commands.
This is implied by -Dynamic.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **CommandType**
The Command Type.  This can allow you to specify the type of command you are overloading.
If the -CommandType includes aliases, and another command is also found, that command will be used.
(this ensures you can continue to overload commands)

|Type        |Required|Position|PipelineInput|Aliases     |
|------------|--------|--------|-------------|------------|
|`[String[]]`|false   |named   |false        |CommandTypes|

#### **ExcludeBlockType**
A list of block types to be excluded during a merge of script blocks.
By default, no blocks will be excluded.
Valid Values:

* using
* requires
* help
* header
* param
* dynamicParam
* begin
* process
* end

|Type        |Required|Position|PipelineInput|Aliases                                               |
|------------|--------|--------|-------------|------------------------------------------------------|
|`[String[]]`|false   |named   |false        |SkipBlockType<br/>SkipBlockTypes<br/>ExcludeBlockTypes|

#### **IncludeBlockType**
A list of block types to include during a merge of script blocks.
Valid Values:

* using
* requires
* help
* header
* param
* dynamicParam
* begin
* process
* end

|Type        |Required|Position|PipelineInput|Aliases                                       |
|------------|--------|--------|-------------|----------------------------------------------|
|`[String[]]`|false   |named   |false        |BlockType<br/>BlockTypes<br/>IncludeBlockTypes|

#### **IncludeParameter**
A list of parameters to include.  Can contain wildcards.
If -IncludeParameter is provided without -ExcludeParameter, all other parameters will be excluded.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **ExcludeParameter**
A list of parameters to exclude.  Can contain wildcards.
Excluded parameters with default values will declare the default value at the beginnning of the command.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |

#### **ArgumentListParameterName**
The ArgumentList parameter name
When inheriting an application, a parameter is created to accept any remaining arguments.
This is the name of that parameter (by default, 'ArgumentList')
This parameter is ignored when inheriting from anything other than an application.

|Type      |Required|Position|PipelineInput|Aliases              |
|----------|--------|--------|-------------|---------------------|
|`[String]`|false   |named   |false        |ArgumentListParameter|

#### **ArgumentListParameterAlias**
The ArgumentList parameter aliases
When inheriting an application, a parameter is created to accept any remaining arguments.
These are the aliases for that parameter (by default, 'Arguments' and 'Args')
This parameter is ignored when inheriting from anything other than an application.

|Type        |Required|Position|PipelineInput|Aliases                                              |
|------------|--------|--------|-------------|-----------------------------------------------------|
|`[String[]]`|false   |named   |false        |ArgumentListParameters<br/>ArgumentListParameterNames|

#### **ArgumentListParameterType**
The ArgumentList parameter type
When inheriting an application, a parameter is created to accept any remaining arguments.
This is the type of that parameter (by default, '[string[]]')
This parameter is ignored when inheriting from anything other than an application.

|Type    |Required|Position|PipelineInput|
|--------|--------|--------|-------------|
|`[Type]`|false   |named   |false        |

#### **ArgumentListParameterHelp**
The help for the argument list parameter.
When inheriting an application, a parameter is created to accept any remaining arguments.
This is the help of that parameter (by default, 'Arguments to $($InhertedApplication.Name)')
This parameter is ignored when inheriting from anything other than an application.

|Type      |Required|Position|PipelineInput|Aliases                         |
|----------|--------|--------|-------------|--------------------------------|
|`[String]`|false   |named   |false        |ArgumentListParameterDescription|

#### **ScriptBlock**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|false   |named   |true (ByValue)|

---

### Syntax
```PowerShell
Template.PipeScript.Inherit [-Command] <String> [-Abstract] [-Override] [-Dynamic] [-NoDynamic] [-Proxy] [-CommandType <String[]>] [-ExcludeBlockType <String[]>] [-IncludeBlockType <String[]>] [-IncludeParameter <String[]>] [-ExcludeParameter <String[]>] [-ArgumentListParameterName <String>] [-ArgumentListParameterAlias <String[]>] [-ArgumentListParameterType <Type>] [-ArgumentListParameterHelp <String>] [-ScriptBlock <ScriptBlock>] [<CommonParameters>]
```

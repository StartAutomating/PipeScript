Import-PipeScript
-----------------

### Synopsis
Imports PipeScript

---

### Description

Imports PipeScript in a dynamic module.

---

### Examples
> EXAMPLE 1

```PowerShell
Import-PipeScript -ScriptBlock {
    function gh {
        [Inherit('gh',CommandType='Application')]
        param()
    }
}
```
> EXAMPLE 2

```PowerShell
Import-PipeScript -ScriptBlock {
    partial function f {
        "This will be added to any function named f."
    }
}
```

---

### Parameters
#### **Command**
The Command to run or ScriptBlock to import.

|Type      |Required|Position|PipelineInput                 |Aliases                                    |
|----------|--------|--------|------------------------------|-------------------------------------------|
|`[Object]`|true    |1       |true (ByValue, ByPropertyName)|ScriptBlock<br/>CommandName<br/>CommandInfo|

#### **AsCustomObject**
Indicates that this returns a custom object with members that represent the imported module members
When you use the AsCustomObject parameter, Import-PipeScript imports the module members into the session and then returns a    
PSCustomObject object instead of a PSModuleInfo object. You can save the custom object in a variable and use dot notation    
to invoke the members.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **PassThru**
Returns an object representing the item with which you're working. By default, this cmdlet does not generate any output.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **Name**
Specifies a name for the imported module.
The default value is an autogenerate name containing the time it was generated.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |

#### **NoTranspile**
If set, will not transpile a -Command that is a [ScriptBlock]
All other types of -Command will be transpiled, disregarding this parameter.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

---

### Syntax
```PowerShell
Import-PipeScript [-Command] <Object> [-AsCustomObject] [-PassThru] [[-Name] <String>] [-NoTranspile] [<CommonParameters>]
```

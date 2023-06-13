ModuleCommandTypes
------------------




### Synopsis
Gets Module Command Types



---


### Description

Gets Custom Command Types defined in a module.

A Module can define custom command Types by having a CommandType(s) hashtable in it's PrivateData or PSData.

The key of the custom command type is it's name.

The value of a custom command type can be a pattern or a hashtable of additional information.



---


### Examples
#### EXAMPLE 1
```PowerShell
{
    $Module = Get-Module PipeScript
    [ModuleCommandType()]$Module
}
```



---


### Parameters
#### **VariableAST**

A VariableExpression.  This variable must contain a module or name of module.






|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[VariableExpressionAst]`|true    |named   |true (ByValue)|





---


### Syntax
```PowerShell
ModuleCommandTypes -VariableAST <VariableExpressionAst> [<CommonParameters>]
```

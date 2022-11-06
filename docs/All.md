All
---
### Synopsis
all keyword

---
### Description

The all keyword is a powerful way to accomplish several useful scenarios with a very natural syntax.

`all` can get all of a set of things that match a criteria and run one or more post-conditions.

---
### Examples
#### EXAMPLE 1
```PowerShell
& {
$glitters = @{glitters=$true}
all that glitters
}.Transpile()
```

#### EXAMPLE 2
```PowerShell
function mallard([switch]$Quack) { $Quack }
Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
. {all functions that quack are ducks}.Transpile()
Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
```

#### EXAMPLE 3
```PowerShell
. {
    $numbers = 1..100
    $null = all $numbers where { ($_ % 2) -eq 1 } are odd
    $null = all $numbers where { ($_ % 2) -eq 0 } are even
}.Transpile()
```
@(
    . { all even $numbers }.Transpile()
).Length

@(
    . { all odd $numbers }.Transpile()
).Length
---
### Parameters
#### **Functions**

If set, include all functions in the input.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Commands**

If set, include all commands in the input.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Cmdlets**

If set, include all cmdlets in the input



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Aliases**

If set, include all aliases in the input



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Applications**

If set, include all applications in the input



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Scripts**

If set, include all applications in the input



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Variables**

If set, include all variables in the inputObject.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Things**

If set, will include all of the variables, aliases, functions, and scripts in the current directory.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **InputObject**

The input to be searched.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Where**

An optional condition



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **For**

The action that will be run



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Sort**

The way to sort data before it is outputted.



> **Type**: ```[Object]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **Descending**

If output should be sorted in descending order.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **CommandAst**

The Command AST



> **Type**: ```[CommandAst]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
All [-Functions] [-Commands] [-Cmdlets] [-Aliases] [-Applications] [-Scripts] [-Variables] [-Things] [[-InputObject] <Object>] [[-Where] <Object>] [[-For] <Object>] [[-Sort] <Object>] [-Descending] -CommandAst <CommandAst> [<CommonParameters>]
```
---


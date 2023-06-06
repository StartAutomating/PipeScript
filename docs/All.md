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
all functions that quack are ducks
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
#### **InputObject**

The input to be searched.






|Type      |Required|Position|PipelineInput        |Aliases                     |
|----------|--------|--------|---------------------|----------------------------|
|`[Object]`|false   |1       |true (ByPropertyName)|In<br/>Of<br/>The<br/>Object|



#### **Functions**

If set, include all functions in the input.






|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|false   |named   |false        |Function|



#### **Commands**

If set, include all commands in the input.






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Command|



#### **Cmdlets**

If set, include all cmdlets in the input






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Cmdlet |



#### **Aliases**

If set, include all aliases in the input






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Alias  |



#### **Applications**

If set, include all applications in the input






|Type      |Required|Position|PipelineInput|Aliases    |
|----------|--------|--------|-------------|-----------|
|`[Switch]`|false   |named   |false        |Application|



#### **Scripts**

If set, include all applications in the input






|Type      |Required|Position|PipelineInput|Aliases                                      |
|----------|--------|--------|-------------|---------------------------------------------|
|`[Switch]`|false   |named   |false        |ExternalScript<br/>Script<br/>ExternalScripts|



#### **Variables**

If set, include all variables in the inputObject.






|Type      |Required|Position|PipelineInput|Aliases |
|----------|--------|--------|-------------|--------|
|`[Switch]`|false   |named   |false        |Variable|



#### **Things**

If set, will include all of the variables, aliases, functions, and scripts in the current directory.






|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Switch]`|false   |named   |false        |Thing  |



#### **Where**

An optional condition






|Type      |Required|Position|PipelineInput        |Aliases                                                                                                                                                                                                                                                                                    |
|----------|--------|--------|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[Object]`|false   |2       |true (ByPropertyName)|That Are<br/>That Have<br/>That<br/>Condition<br/>Where-Object<br/>With a<br/>With the<br/>With<br/>That Match<br/>Match<br/>Matching<br/>That Matches<br/>Match Expression<br/>Match Regular Expression<br/>Match Pattern<br/>Matches Pattern<br/>That Are Like<br/>Like<br/>Like Wildcard|



#### **For**

The action that will be run






|Type      |Required|Position|PipelineInput        |Aliases                                                                                                       |
|----------|--------|--------|---------------------|--------------------------------------------------------------------------------------------------------------|
|`[Object]`|false   |3       |true (ByPropertyName)|Is<br/>Are<br/>Foreach<br/>Foreach-Object<br/>Can<br/>Could<br/>Should<br/>Is A<br/>Is An<br/>Are a<br/>Are an|



#### **Sort**

The way to sort data before it is outputted.






|Type      |Required|Position|PipelineInput        |Aliases                                                                   |
|----------|--------|--------|---------------------|--------------------------------------------------------------------------|
|`[Object]`|false   |4       |true (ByPropertyName)|sorted by<br/>sort by<br/>sort on<br/>sorted on<br/>sorted<br/>Sort-Object|



#### **Descending**

If output should be sorted in descending order.






|Type      |Required|Position|PipelineInput        |Aliases  |
|----------|--------|--------|---------------------|---------|
|`[Switch]`|false   |named   |true (ByPropertyName)|ascending|



#### **CommandAst**

The Command AST






|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|





---


### Syntax
```PowerShell
All [[-InputObject] <Object>] [-Functions] [-Commands] [-Cmdlets] [-Aliases] [-Applications] [-Scripts] [-Variables] [-Things] [[-Where] <Object>] [[-For] <Object>] [[-Sort] <Object>] [-Descending] -CommandAst <CommandAst> [<CommonParameters>]
```

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
> EXAMPLE 1

```PowerShell
& {
$glitters = @{glitters=$true}
all that glitters
}.Transpile()
```
> EXAMPLE 2

```PowerShell
function mallard([switch]$Quack) { $Quack }
Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
all functions that quack are ducks
Get-Command mallard | Get-Member  | Select-Object -ExpandProperty TypeName -Unique
```
> EXAMPLE 3

```PowerShell
. {
    $numbers = 1..100
    $null = all $numbers where { ($_ % 2) -eq 1 } are odd
    $null = all $numbers where { ($_ % 2) -eq 0 } are even
}.Transpile()
@(
    . { all even $numbers }.Transpile()
).Length

@(
    . { all odd $numbers }.Transpile()
).Length
```

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
A condition.
If the condition is a ScriptBlock, it will act similar to Where-Object.
If the condition is not a script block, the conditional will be inferred by the word choice.
For example:
~~~PowerShell
all functions matching PipeScript
~~~
will return all functions that match the pattern 'PipeScript'
Or:
~~~PowerShell
all in 1..100 greater than 50
~~~
will return all numbers in 1..100 that are greater than 50.
Often, these conditionals will be checked against multiple targets.
For example:
~~~PowerShell
all cmdlets that ID
~~~
Will check all cmdlets to see if:
* they are named "ID"
* OR they have members named "ID"
* OR they have parameters named "ID"
* OR their PSTypenames contains "ID"

|Type      |Required|Position|PipelineInput        |Aliases                                                                                                                                                                                                                                                                                                                                                                                                                     |
|----------|--------|--------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[Object]`|false   |2       |true (ByPropertyName)|That Are<br/>That Have<br/>That<br/>Condition<br/>Where-Object<br/>With a<br/>With the<br/>With<br/>That Match<br/>Match<br/>Matching<br/>That Matches<br/>Match Expression<br/>Match Regular Expression<br/>Match Pattern<br/>Matches Pattern<br/>That Are Like<br/>Like<br/>Like Wildcard<br/>Greater Than<br/>Greater<br/>Greater Than Or Equal<br/>GT<br/>GE<br/>Less Than<br/>Less<br/>Less Than Or Equal<br/>LT<br/>LE|

#### **For**
An action that will be run on every returned item.
As with the -Where parameter, the word choice used for For can be impactful.
In most circumstances, passing a [ScriptBlock] will work similarly to a foreach statment.
When "Should" is present within the word choice, it attach that script as an expectation that can be checked later.

|Type      |Required|Position|PipelineInput        |Aliases                                                                                                                                                                                                        |
|----------|--------|--------|---------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[Object]`|false   |3       |true (ByPropertyName)|Is<br/>Are<br/>Foreach<br/>Foreach-Object<br/>Can<br/>And Can<br/>Could<br/>And Could<br/>Should<br/>And Should<br/>Is A<br/>And Is A<br/>Is An<br/>And Is An<br/>Are a<br/>And Are a<br/>Are an<br/>And Are An|

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
The Command AST.
This parameter and parameter set are present so that this command can be transpiled from source, and are unlikely to be used.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
All [[-InputObject] <Object>] [-Functions] [-Commands] [-Cmdlets] [-Aliases] [-Applications] [-Scripts] [-Variables] [-Things] [[-Where] <Object>] [[-For] <Object>] [[-Sort] <Object>] [-Descending] -CommandAst <CommandAst> [<CommonParameters>]
```

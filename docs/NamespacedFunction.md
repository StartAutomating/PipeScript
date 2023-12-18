NamespacedFunction
------------------

### Synopsis
Namespaced functions

---

### Description

Allows the declaration of a function or filter in a namespace.

Namespaces are used to logically group functionality and imply standardized behavior.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    abstract function Point {
        param(
        [Alias('Left')]
        [vbn()]
        $X,
[Alias('Top')]
        [vbn()]
        $Y
        )
    }
}.Transpile()
```
> EXAMPLE 2

```PowerShell
{
    interface function AccessToken {
        param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Bearer','PersonalAccessToken', 'PAT')]
        [string]
        $AccessToken
        )
    }
}.Transpile()
```
> EXAMPLE 3

```PowerShell
{
    partial function PartialExample {
        process {
            1
        }
    }
partial function PartialExample* {
        process {
            2
        }
    }

    partial function PartialExample// {
        process {
            3
        }
    }        

    function PartialExample {
        
    }
}.Transpile()
```

---

### Parameters
#### **CommandAst**
The CommandAST that will be transformed.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
NamespacedFunction [-CommandAst] <CommandAst> [<CommonParameters>]
```

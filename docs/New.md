New
---

### Synopsis
'new' keyword

---

### Description

This transpiler enables the use of the keyword 'new'.

new acts as it does in many other languages.  

It creates an instance of an object.

'new' can be followed by a typename and any number of arguments or hashtables.

If 'new' is followed by a single string, and the type has a ::Parse method, new will parse the value.

---

### Examples
> EXAMPLE 1

```PowerShell
{ new DateTime }
```
> EXAMPLE 2

```PowerShell
{ new byte 1 }
```
> EXAMPLE 3

```PowerShell
{ new int[] 5 }
```
> EXAMPLE 4

```PowerShell
{ new Timespan }
```
> EXAMPLE 5

```PowerShell
{ new datetime 12/31/1999 }
```
> EXAMPLE 6

```PowerShell
{ new @{RandomNumber = Get-Random; A ='b'}}
```
> EXAMPLE 7

```PowerShell
{ new Diagnostics.ProcessStartInfo @{FileName='f'} }
```
> EXAMPLE 8

```PowerShell
{ new ScriptBlock 'Get-Command'}
```
> EXAMPLE 9

```PowerShell
{ (new PowerShell).AddScript("Get-Command").Invoke() }
```
> EXAMPLE 10

```PowerShell
{ new 'https://schema.org/Thing' }
```

---

### Parameters
#### **CommandAst**

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Syntax
```PowerShell
New [-CommandAst] <CommandAst> [<CommonParameters>]
```

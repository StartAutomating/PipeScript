
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

If 'new'

---
### Examples
#### EXAMPLE 1
```PowerShell
{ new DateTime }
```

#### EXAMPLE 2
```PowerShell
{ new byte 1 }
```

#### EXAMPLE 3
```PowerShell
{ new int[] 5 }
```

#### EXAMPLE 4
```PowerShell
{ new datetime 12/31/1999 }
```

#### EXAMPLE 5
```PowerShell
{ new @{RandomNumber = Get-Random; A ='b'}}
```

#### EXAMPLE 6
```PowerShell
{ new Diagnostics.ProcessStartInfo @{FileName='f'} }
```

---
### Parameters
#### **CommandAst**

|Type              |Requried|Postion|PipelineInput |
|------------------|--------|-------|--------------|
|```[CommandAst]```|true    |1      |true (ByValue)|
---
### Syntax
```PowerShell
New [-CommandAst] <CommandAst> [<CommonParameters>]
```
---



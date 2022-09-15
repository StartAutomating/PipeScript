
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
{ new Timespan }
```

#### EXAMPLE 5
```PowerShell
{ new datetime 12/31/1999 }
```

#### EXAMPLE 6
```PowerShell
{ new @{RandomNumber = Get-Random; A =&#39;b&#39;}}
```

#### EXAMPLE 7
```PowerShell
{ new Diagnostics.ProcessStartInfo @{FileName=&#39;f&#39;} }
```

#### EXAMPLE 8
```PowerShell
{ new ScriptBlock &#39;Get-Command&#39;}
```

#### EXAMPLE 9
```PowerShell
{ (new PowerShell).AddScript(&quot;Get-Command&quot;).Invoke() }
```

#### EXAMPLE 10
```PowerShell
{ new &#39;https://schema.org/Thing&#39; }
```

---
### Parameters
#### **CommandAst**

> **Type**: ```[CommandAst]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
New [-CommandAst] &lt;CommandAst&gt; [&lt;CommonParameters&gt;]
```
---




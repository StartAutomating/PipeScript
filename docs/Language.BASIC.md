Language.BASIC
--------------

### Synopsis
BASIC Language Definition.

---

### Description

Allows PipeScript to generate Basic, Visual Basic, and Visual Basic Scripts.

Because Basic only allow single-line comments, this is done using a pair of comment markers.

A single line comment, followed by a { (or PipeScript { ) begins a block of pipescript.

A single line comment, followed by a } (or PipeScript } ) ends a block of pipescript.

Only commented lines within this block will be interpreted as PipeScript.
        
```VBScript    
rem {

rem # Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $VBScript = '    
rem {
rem # Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
'

    [OutputFile('.\HelloWorld.ps1.vbs')]$VBScript
}

Invoke-PipeScript .\HelloWorld.ps1.vbs
```

---

### Syntax
```PowerShell
Language.BASIC [<CommonParameters>]
```

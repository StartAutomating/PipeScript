Language.TCL
------------

### Synopsis
TCL/TK PipeScript Language Definition.

---

### Description

Allows PipeScript to generate TCL or TK.

Because TCL Scripts only allow single-line comments, this is done using a pair of comment markers.

# { or # PipeScript{  begins a PipeScript block

# } or # }PipeScript  ends a PipeScript block

~~~tcl    
# {

Uncommented lines between these two points will be ignored

#  # Commented lines will become PipeScript / PowerShell.
# param($message = "hello world")
# "puts `"$message`""

# }
~~~

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $tclScript = '    
# {
# # Uncommented lines between these two points will be ignored

#  # Commented lines will become PipeScript / PowerShell.
# param($message = "hello world")
# "puts `"$message`""

# }
'

    [OutputFile('.\HelloWorld.ps1.tcl')]$tclScript
}

Invoke-PipeScript .\HelloWorld.ps1.tcl
```

---

### Syntax
```PowerShell
Language.TCL [<CommonParameters>]
```

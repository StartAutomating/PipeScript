Language.R
----------

### Synopsis
R PipeScript Language Definition.

---

### Description

Allows PipeScript to generate R.

Because R Scripts only allow single-line comments, this is done using a pair of comment markers.

# { or # PipeScript{  begins a PipeScript block

# } or # }PipeScript  ends a PipeScript block

~~~r    
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
    $rScript = '    
# {
Uncommented lines between these two points will be ignored

#  # Commented lines will become PipeScript / PowerShell.
# param($message = "hello world")
# "print(`"$message`")"

# }
'

    [OutputFile('.\HelloWorld.ps1.r')]$rScript
}

Invoke-PipeScript .\HelloWorld.ps1.r
```

---

### Syntax
```PowerShell
Language.R [<CommonParameters>]
```

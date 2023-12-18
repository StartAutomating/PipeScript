Language.Batch
--------------

### Synopsis
Batch Language Definition.

---

### Description

Allows PipeScript to generate Windows Batch Scripts.

Because Batch Scripts only allow single-line comments, this is done using a pair of comment markers.
        

```batch    
:: {

:: Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = 'hello world')
:: "echo $message"

:: }
```

---

### Examples
> EXAMPLE 1

```PowerShell
Invoke-PipeScript {
    $batchScript = '    
:: {
:: # Uncommented lines between these two points will be ignored

:: # Commented lines will become PipeScript / PowerShell.
:: param($message = "hello world")
:: "echo $message"

:: }
'

    [OutputFile('.\HelloWorld.ps1.cmd')]$batchScript
}

Invoke-PipeScript .\HelloWorld.ps1.cmd
```

---

### Syntax
```PowerShell
Language.Batch [<CommonParameters>]
```

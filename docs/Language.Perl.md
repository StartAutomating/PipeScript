Language.Perl
-------------

### Synopsis
Perl Template Transpiler.

---

### Description

Allows PipeScript to generate Perl.

Also Transpiles Plain Old Document

PipeScript can be embedded in a Plain Old Document block that starts with ```=begin PipeScript``` and ends with ```=end PipeScript```.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $HelloWorldPerl = @'
=begin PipeScript
$msg = "hello", "hi", "hey", "howdy" | Get-Random
"print(" + '"' + $msg + '");'
=end   PipeScript
'@
[Save(".\HelloWorld.ps1.pl")]$HelloWorldPerl
}

.> .\HelloWorld.ps1.pl
```

---

### Syntax
```PowerShell
Language.Perl [<CommonParameters>]
```

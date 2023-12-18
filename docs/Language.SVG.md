Language.SVG
------------

### Synopsis
SVG PipeScript Language Definition.

---

### Description

Allows PipeScript to generate SVG.

Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

---

### Examples
> EXAMPLE 1

```PowerShell
$starsTemplate = Invoke-PipeScript {
    Stars.svg template '
        <!--{
            Invoke-RestMethod https://pssvg.start-automating.com/Examples/Stars.svg
        }-->
    '
}
$starsTemplate.Save("$pwd\Stars.svg")
```

---

### Syntax
```PowerShell
Language.SVG [<CommonParameters>]
```

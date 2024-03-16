PipeScript.Techs.ForFile()
--------------------------

### Synopsis
Gets the language for a file.

---

### Description

Gets the PipeScript language definitions for a path.

---

### Examples
> EXAMPLE 1

```PowerShell
$PSLanguage.ForFile("a.xml")
```
> EXAMPLE 2

```PowerShell
$PSInterpreters.ForFile("a.js")
```

---

### Parameters
#### **FilePath**
The path to the file, or the name of the command.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

---

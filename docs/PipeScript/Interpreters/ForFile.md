PipeScript.Interpreters.ForFile()
---------------------------------

### Synopsis
Gets the language for a file.

---

### Description

Gets the PipeScript language definitions for a file path.

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

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

---

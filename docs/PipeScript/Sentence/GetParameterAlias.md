PipeScript.Sentence.GetParameterAlias()
---------------------------------------

### Synopsis
Gets a parameter's alias

---

### Description

Gets the alias used to call a parameter in a sentence.

This can be useful for inferring subtle differences based off of word choice, as in

`all functions matching Sentence` # Returns all functions that match Sentence

Compared to:

`all functions where Sentence` # Returns all functions that are Sentences

---

### Examples
> EXAMPLE 1

```PowerShell
{* pid $pid}.Ast.EndBlock.Statements[0].PipelineElements[0].AsSentence((Get-Command Get-Process)).GetParameterAlias('id')
```

---

### Parameters
#### **Parameter**
The name of one or more parameters.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |1       |false        |

---

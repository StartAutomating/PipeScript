System.Management.Automation.ScriptBlock.IsEquivalentTo()
---------------------------------------------------------

### Synopsis
Attempts to Determine Ast Equivalence

---

### Description

Attempts to Determine if `$this` Ast element is the same as some `$Other` object.

If `$Other is a `[string]`, it will be converted into a `[ScriptBlock]`
If `$Other is a `[ScriptBlock]`, it will become the `[ScriptBlock]`s AST

If the types differ, `$other is not equivalent to `$this.

If the content is the same with all whitespace removed, it will be considered equivalent.

---

### Parameters
#### **Other**
The other item.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |1       |false        |

---

### Notes
Due to the detection mechanism, IsEquivalentTo will consider strings with whitespace changes equivalent.

---

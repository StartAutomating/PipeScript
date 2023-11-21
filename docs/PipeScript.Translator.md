PipeScript.Translator
---------------------

### Synopsis
PipeScript Translator

---

### Description

Allows optional translation of PowerShell into another language.

For this to work, the language must support this translation (by implementing `TranslatePowerShell()` or `TranslateNameOfASTType`).

Any pair of statements taking the form `... in <Language>` will attempt a translation.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    enum Foo {
        Bar = 1
        Baz = 2
        Bing = 3
    } in CSharp
} | Use-PipeScript
```

---

### Parameters
#### **CommandAst**
The CommandAST

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |named   |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.Translator -CommandAst <CommandAst> [<CommonParameters>]
```

Compile.LanguageDefinition
--------------------------

### Synopsis
Compiles a language definition

---

### Description

Compiles a language definition.

Language definitions integrate languages into PipeScript, so that they can be templated, interpreted, and compiled.

---

### Examples
> EXAMPLE 1

```PowerShell
Import-PipeScript {         
    language function TestLanguage {
        $AnyVariableInThisBlock = 'Will Become a Property'
    }
}
```

---

### Parameters
#### **LanguageDefinition**
A Language Definition, as a Script Block

|Type           |Required|Position|PipelineInput |Aliases                   |
|---------------|--------|--------|--------------|--------------------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|ScriptBlock<br/>Definition|

#### **LanguageFunctionAst**
A Language Function Definition

|Type                     |Required|Position|PipelineInput |
|-------------------------|--------|--------|--------------|
|`[FunctionDefinitionAst]`|true    |named   |true (ByValue)|

---

### Outputs
* [Management.Automation.ScriptBlock](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.ScriptBlock)

* [Management.Automation.Language.FunctionDefinitionAst](https://learn.microsoft.com/en-us/dotnet/api/System.Management.Automation.Language.FunctionDefinitionAst)

---

### Notes
Language definitions are an open-ended object.

By providing key properties or methods, a language can support a variety of scenarios.

|Scenario|Required Properties|
|-|-|
|Templating    | `.StartPattern`, `.EndPattern`|
|Interpretation| `.Interpreter`                |

Language definitions should not contain named blocks.

---

### Syntax
```PowerShell
Compile.LanguageDefinition -LanguageDefinition <ScriptBlock> [<CommonParameters>]
```
```PowerShell
Compile.LanguageDefinition -LanguageFunctionAst <FunctionDefinitionAst> [<CommonParameters>]
```

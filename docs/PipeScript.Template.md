PipeScript.Template
-------------------

### Synopsis
Template Transpiler

---

### Description

The PipeScript Core Template Transpiler.

This allows PipeScript to generate many other languages.

Regardless of the underlying language, the core template transpiler works in a fairly straightforward way.

A language will contain PipeScript within the file (usually in comments).

If a Regular Expression can match each section, then the content in each section can be replaced.

When a file that can be transpiled is encountered,
the template transpiler for that file type will call the core template transpiler.

When templates are used as a keyword,
the template transpiler will produce an object that can evaluate the template on demand.

---

### Parameters
#### **SourceText**
A string containing the text contents of the file

|Type      |Required|Position|PipelineInput|Aliases     |
|----------|--------|--------|-------------|------------|
|`[String]`|false   |1       |false        |TemplateText|

#### **ReplacePattern**

|Type     |Required|Position|PipelineInput|Aliases|
|---------|--------|--------|-------------|-------|
|`[Regex]`|false   |2       |false        |Replace|

#### **ReplaceTimeout**
The timeout for a replacement.  By default, 15 seconds.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |3       |false        |

#### **TemplateName**
The name of the template.  This can be implied by the pattern.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Object]`|false   |4       |false        |Name   |

#### **StartPattern**
The Start Pattern.
This indicates the beginning of what should be considered PipeScript.
An expression will match everything until -EndPattern

|Type     |Required|Position|PipelineInput|Aliases   |
|---------|--------|--------|-------------|----------|
|`[Regex]`|false   |5       |false        |StartRegex|

#### **EndPattern**
The End Pattern
This indicates the end of what should be considered PipeScript.

|Type     |Required|Position|PipelineInput|Aliases |
|---------|--------|--------|-------------|--------|
|`[Regex]`|false   |6       |false        |EndRegex|

#### **ReplacementEvaluator**
A custom replacement evaluator.
If not provided, will run any embedded scripts encountered. 
The output of these scripts will be the replacement text.

|Type           |Required|Position|PipelineInput|Aliases |
|---------------|--------|--------|-------------|--------|
|`[ScriptBlock]`|false   |7       |false        |Replacer|

#### **NoTranspile**
If set, will not transpile script blocks.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **SourceFile**
The path to the source file.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |8       |false        |

#### **Begin**
A Script Block that will be injected before each inline is run.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[ScriptBlock]`|false   |9       |false        |

#### **ForeachObject**
A Script Block that will be piped to after each output.

|Type           |Required|Position|PipelineInput|Aliases|
|---------------|--------|--------|-------------|-------|
|`[ScriptBlock]`|false   |10      |false        |Process|

#### **End**
A Script Block that will be injected after each inline script is run.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[ScriptBlock]`|false   |11      |false        |

#### **Parameter**
A collection of parameters

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |12      |false        |

#### **ArgumentList**
An argument list.

|Type          |Required|Position|PipelineInput|Aliases|
|--------------|--------|--------|-------------|-------|
|`[PSObject[]]`|false   |13      |false        |Args   |

#### **LinePattern**
Some languages only allow single-line comments.
To work with these languages, provide a -LinePattern indicating what makes a comment
Only lines beginning with this pattern within -StartPattern and -EndPattern will be considered a script.

|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Regex]`|false   |14      |false        |

#### **AsScriptBlock**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **CommandAst**
The Command Abstract Syntax Tree.  If this is provided, we are transpiling a template keyword.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|false   |15      |true (ByValue)|

---

### Syntax
```PowerShell
PipeScript.Template [[-SourceText] <String>] [[-ReplacePattern] <Regex>] [[-ReplaceTimeout] <TimeSpan>] [[-TemplateName] <Object>] [[-StartPattern] <Regex>] [[-EndPattern] <Regex>] [[-ReplacementEvaluator] <ScriptBlock>] [-NoTranspile] [[-SourceFile] <String>] [[-Begin] <ScriptBlock>] [[-ForeachObject] <ScriptBlock>] [[-End] <ScriptBlock>] [[-Parameter] <IDictionary>] [[-ArgumentList] <PSObject[]>] [[-LinePattern] <Regex>] [-AsScriptBlock] [[-CommandAst] <CommandAst>] [<CommonParameters>]
```

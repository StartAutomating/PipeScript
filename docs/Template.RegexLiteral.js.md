Template.RegexLiteral.js
------------------------

### Synopsis
Template for a JavaScript regex literal

---

### Description

Template for regex literal in JavaScript.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.RegexLiteral.js -Pattern "\d+"
```

---

### Parameters
#### **Pattern**
The pattern.

|Type      |Required|Position|PipelineInput        |Aliases                                   |
|----------|--------|--------|---------------------|------------------------------------------|
|`[String]`|false   |1       |true (ByPropertyName)|Expression<br/>RegularExpression<br/>RegEx|

#### **Flag**
The regular expression flags
Valid Values:

* d
* hasIndices
* g
* global
* i
* ignoreCase
* m
* multiline
* s
* dotAll
* u
* unicode
* v
* unicodeSets
* y
* sticky

|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[String[]]`|false   |2       |false        |Flags  |

---

### Syntax
```PowerShell
Template.RegexLiteral.js [[-Pattern] <String>] [[-Flag] <String[]>] [<CommonParameters>]
```

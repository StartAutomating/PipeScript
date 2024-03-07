Template.HTML.Element
---------------------

### Synopsis
Template for an HTML element.

---

### Description

A Template for an HTML element.

---

### Related Links
* [https://developer.mozilla.org/en-US/docs/Web/HTML/Element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element)

---

### Parameters
#### **Name**
The name of the element.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **Attribute**
The attributes of the element.

|Type        |Required|Position|PipelineInput        |Aliases   |
|------------|--------|--------|---------------------|----------|
|`[PSObject]`|false   |2       |true (ByPropertyName)|Attributes|

#### **Content**
The content of the element.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.HTML.Element [[-Name] <String>] [[-Attribute] <PSObject>] [[-Content] <String>] [<CommonParameters>]
```

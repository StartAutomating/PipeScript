PipeScript.Module.Topic.FindHyperlinks()
----------------------------------------

### Synopsis
Matches a Markdown Link

---

### Description

Matches a Markdown Link.  Can customize the link text and link url.

---

### Parameters
#### **LinkText**
The text of the link.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |1       |false        |

#### **LinkUri**
The link URI.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[Object]`|false   |2       |false        |LinkUrl|

---

### Notes
This only matches simple markdown links.  It does not currently match links with titles.

---

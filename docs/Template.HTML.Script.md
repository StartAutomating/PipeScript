Template.HTML.Script
--------------------

### Synopsis
Template for a Script tag

---

### Description

A Template for the script tag.

---

### Parameters
#### **Url**
The URL of the script.

|Type   |Required|Position|PipelineInput        |Aliases     |
|-------|--------|--------|---------------------|------------|
|`[Uri]`|false   |1       |true (ByPropertyName)|Uri<br/>Link|

#### **JavaScript**
The inline JavaScript.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |2       |true (ByPropertyName)|Script |

#### **Async**
If the script should be loaded asynchronously.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **NoModule**
If the script should not allow EMCA modules

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Defer**
If the script should be deferred.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Blocking**
If the script should be blocking.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **FetchPriority**
The fetch priority of the script.
Valid Values:

* high
* low
* auto

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **CrossOrigin**
The cross-origin policy of the script.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |4       |true (ByPropertyName)|CORS   |

#### **Integrity**
The integrity value of the script.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|

#### **Nonce**
The nonce value of the script.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **ReferrerPolicy**
The referrer policy of the script.
Valid Values:

* no-referrer
* no-referrer-when-downgrade
* origin
* origin-when-cross-origin
* same-origin
* strict-origin
* strict-origin-when-cross-origin
* unsafe-url

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **ScriptType**
The script type

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |8       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.HTML.Script [[-Url] <Uri>] [[-JavaScript] <String>] [-Async] [-NoModule] [-Defer] [-Blocking] [[-FetchPriority] <String>] [[-CrossOrigin] <String>] [[-Integrity] <String>] [[-Nonce] <String>] [[-ReferrerPolicy] <String>] [[-ScriptType] <String>] [<CommonParameters>]
```

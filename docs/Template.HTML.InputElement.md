Template.HTML.InputElement
--------------------------

### Synopsis
Template for an HTML input.

---

### Description

A Template for an HTML input element.

---

### Related Links
* [https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input)

---

### Parameters
#### **Name**
The name of the input.

|Type      |Required|Position|PipelineInput        |Aliases  |
|----------|--------|--------|---------------------|---------|
|`[String]`|false   |named   |true (ByPropertyName)|InputName|

#### **InputType**
The type of input.
Valid Values:

* button
* checkbox
* color
* date
* datetime-local
* email
* file
* hidden
* image
* month
* number
* password
* radio
* range
* reset
* search
* submit
* tel
* text
* time
* url
* week

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|type   |

#### **ID**
The ID of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Value**
The value of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Placeholder**
The placeholder of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Required**
If the input is required.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Disabled**
If the input is disabled.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **ReadOnly**
If the input is readonly.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Checked**
If the input is checked.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Min**
The minimum value of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Max**
The maximum value of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Step**
The step value of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Pattern**
The pattern of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **AutoComplete**
The autocomplete of the input.
Valid Values:

* on
* off

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Form**
The form that the input is associated with.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FormAction**
The formaction of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **FormEncodingType**
The formenctype of the input.
Valid Values:

* application/x-www-form-urlencoded
* multipart/form-data
* text/plain

|Type      |Required|Position|PipelineInput        |Aliases                |
|----------|--------|--------|---------------------|-----------------------|
|`[String]`|false   |named   |true (ByPropertyName)|FormEnc<br/>FormEncType|

#### **FormMethod**
The formmethod of the input.
Valid Values:

* get
* post

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |named   |true (ByPropertyName)|FormMeth|

#### **FormNoValidate**
The formnovalidate of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **FormTarget**
The formtarget of the input.
Valid Values:

* _blank
* _self
* _parent
* _top

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |named   |true (ByPropertyName)|FormTarg|

#### **Height**
The height of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Width**
The width of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **List**
The list of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **MinLength**
The minimum length of the input.

|Type     |Required|Position|PipelineInput        |Aliases      |
|---------|--------|--------|---------------------|-------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|MinimumLength|

#### **Multiple**
If set, an email input can accept multiple emails, or a file input can accept multiple files.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

#### **Size**
The size of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **Accept**
The accept of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **AcceptCharset**
The accept-charset of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|

#### **AutoFocus**
The autofocus of the input.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Syntax
```PowerShell
Template.HTML.InputElement [-Name <String>] [-InputType <String>] [-ID <String>] [-Value <String>] [-Placeholder <String>] [-Required] [-Disabled] [-ReadOnly] [-Checked] [-Min <String>] [-Max <String>] [-Step <String>] [-Pattern <String>] [-AutoComplete <String>] [-Form <String>] [-FormAction <String>] [-FormEncodingType <String>] [-FormMethod <String>] [-FormNoValidate] [-FormTarget <String>] [-Height <String>] [-Width <String>] [-List <String>] [-MinLength <Int32>] [-Multiple] [-Size <String>] [-Accept <String>] [-AcceptCharset <String>] [-AutoFocus] [<CommonParameters>]
```

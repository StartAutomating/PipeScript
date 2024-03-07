Template.HTML.CustomElement
---------------------------

### Synopsis
Template for a custom HTML element.

---

### Description

A Template for a custom HTML element.

Creates the JavaScript for a custom HTML element.

---

### Related Links
* [https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements)

---

### Examples
> EXAMPLE 1

Hello, World!</p>"  -OnConnected "
    console.log('Hello, World!')
"
Template.HTML.Element -Name "hello-world"

---

### Parameters
#### **ElementName**
The name of the element.  By default, custom-element.

|Type      |Required|Position|PipelineInput        |Aliases         |
|----------|--------|--------|---------------------|----------------|
|`[String]`|false   |1       |true (ByPropertyName)|Element<br/>Name|

#### **ClassName**
The class name.
If not provided, it will be derived from the element name.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |2       |true (ByPropertyName)|Class  |

#### **ExtendClass**
The class that the element extends.  By default, HTMLElement.

|Type      |Required|Position|PipelineInput        |Aliases           |
|----------|--------|--------|---------------------|------------------|
|`[String]`|false   |3       |true (ByPropertyName)|Extends<br/>Extend|

#### **ExtendElement**
The base HTML element that is being extended.
If a specific element is extended, you can create a control in form:
~~~html
<ElementName is="custom-element"></ElementName>
~~~

|Type      |Required|Position|PipelineInput        |Aliases       |
|----------|--------|--------|---------------------|--------------|
|`[String]`|false   |4       |true (ByPropertyName)|ExtendElements|

#### **Parameter**
The parameters to any template.

|Type        |Required|Position|PipelineInput        |Aliases   |
|------------|--------|--------|---------------------|----------|
|`[PSObject]`|false   |5       |true (ByPropertyName)|Parameters|

#### **Property**
The properties for the element.
If multiple values are provided, the property will be gettable and settable.

|Type        |Required|Position|PipelineInput        |Aliases   |
|------------|--------|--------|---------------------|----------|
|`[PSObject]`|false   |6       |true (ByPropertyName)|Properties|

#### **Template**
The template content, or the ID of a template.

|Type      |Required|Position|PipelineInput        |Aliases                                   |
|----------|--------|--------|---------------------|------------------------------------------|
|`[String]`|false   |7       |true (ByPropertyName)|TemplateID<br/>TemplateContent<br/>Content|

#### **OnConnected**
The JavaScript to run when the element is connected.

|Type      |Required|Position|PipelineInput        |Aliases                                                  |
|----------|--------|--------|---------------------|---------------------------------------------------------|
|`[String]`|false   |8       |true (ByPropertyName)|OnConnection<br/>ConnectedCallback<br/>ConnectionCallback|

#### **OnDisconnected**
The JavaScript to run when the element is disconnected.

|Type      |Required|Position|PipelineInput        |Aliases                                                           |
|----------|--------|--------|---------------------|------------------------------------------------------------------|
|`[String]`|false   |9       |true (ByPropertyName)|OnDisconnection<br/>DisconnectedCallback<br/>DisconnectionCallback|

#### **OnAdopted**
The JavaScript to run when the element is adopted.

|Type      |Required|Position|PipelineInput        |Aliases                                            |
|----------|--------|--------|---------------------|---------------------------------------------------|
|`[String]`|false   |10      |true (ByPropertyName)|OnAdoption<br/>AdoptedCallback<br/>AdoptionCallback|

#### **OnAttributeChange**
The JavaScript to run when attributes are updated.

|Type      |Required|Position|PipelineInput        |Aliases                                                                    |
|----------|--------|--------|---------------------|---------------------------------------------------------------------------|
|`[String]`|false   |11      |true (ByPropertyName)|OnAttributeChanged<br/>AttributeChangeCallback<br/>AttributeChangedCallback|

#### **ObservableAttribute**
The list of observable attributes.

|Type        |Required|Position|PipelineInput        |Aliases                            |
|------------|--------|--------|---------------------|-----------------------------------|
|`[String[]]`|false   |12      |true (ByPropertyName)|ObservableAttributes<br/>Observable|

---

### Syntax
```PowerShell
Template.HTML.CustomElement [[-ElementName] <String>] [[-ClassName] <String>] [[-ExtendClass] <String>] [[-ExtendElement] <String>] [[-Parameter] <PSObject>] [[-Property] <PSObject>] [[-Template] <String>] [[-OnConnected] <String>] [[-OnDisconnected] <String>] [[-OnAdopted] <String>] [[-OnAttributeChange] <String>] [[-ObservableAttribute] <String[]>] [<CommonParameters>]
```

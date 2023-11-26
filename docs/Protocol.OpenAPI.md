Protocol.OpenAPI
----------------

### Synopsis
OpenAPI protocol

---

### Description

Converts an OpenAPI to PowerShell.

This protocol will generate a PowerShell script to communicate with an OpenAPI.

---

### Examples
We can easily create a command that talks to a single REST api described in OpenAPI.

```PowerShell
Import-PipeScript {
    function Get-GitHubIssue
    {
        [OpenAPI(SchemaURI=
            'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json#/repos/{owner}/{repo}/issues/get')]    
        param()
    }
}
Get-GitHubIssue -Owner StartAutomating -Repo PipeScript
```
We can also make a general purpose command that talks to every endpoint in a REST api.

```PowerShell
Import-PipeScript {
    function GitHubApi
    {
        [OpenAPI(SchemaURI='https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json')]
        param()
    }
}
GitHubApi '/zen'
```
We can also use OpenAPI as a command.  Just pass a URL, and get back a script block.

```PowerShell
openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get
```
> EXAMPLE 4

```PowerShell
$TranspiledOpenAPI = { openapi https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml#/models/get } |
    Use-PipeScript
& $TranspiledOpenAPI # Should -BeOfType ([ScriptBlock])
```

---

### Parameters
#### **SchemaUri**
The OpenAPI SchemaURI.

|Type   |Required|Position|PipelineInput|
|-------|--------|--------|-------------|
|`[Uri]`|true    |named   |false        |

#### **CommandAst**
The Command's Abstract Syntax Tree.
This is provided by PipeScript when transpiling a protocol.

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[CommandAst]`|true    |named   |false        |

#### **ScriptBlock**
The ScriptBlock.
This is provided when transpiling the protocol as an attribute.
Providing a value here will run this script's contents, rather than a default implementation.

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **RemovePropertyPrefix**
One or more property prefixes to remove.
Properties that start with this prefix will become parameters without the prefix.

|Type        |Required|Position|PipelineInput|Aliases               |
|------------|--------|--------|-------------|----------------------|
|`[String[]]`|false   |named   |false        |Remove Property Prefix|

#### **ExcludeProperty**
One or more properties to ignore.
Properties whose name or description is like this keyword will be ignored.

|Type        |Required|Position|PipelineInput|Aliases                                                              |
|------------|--------|--------|-------------|---------------------------------------------------------------------|
|`[String[]]`|false   |named   |false        |Ignore Property<br/>IgnoreProperty<br/>SkipProperty<br/>Skip Property|

#### **IncludeProperty**
One or more properties to include.
Properties whose name or description is like this keyword will be included.

|Type        |Required|Position|PipelineInput|Aliases         |
|------------|--------|--------|-------------|----------------|
|`[String[]]`|false   |named   |false        |Include Property|

#### **AccessTokenParameter**
The name of the parameter used for an access token.
By default, this will be 'AccessToken'

|Type      |Required|Position|PipelineInput|Aliases               |
|----------|--------|--------|-------------|----------------------|
|`[String]`|false   |named   |false        |Access Token Parameter|

#### **AccessTokenAlias**
The name of the parameter aliases used for an access token

|Type        |Required|Position|PipelineInput|Aliases             |
|------------|--------|--------|-------------|--------------------|
|`[String[]]`|false   |named   |false        |Access Token Aliases|

#### **NoMandatory**
If set, will not mark a parameter as required, even if the schema indicates it should be.

|Type      |Required|Position|PipelineInput|Aliases                                                                               |
|----------|--------|--------|-------------|--------------------------------------------------------------------------------------|
|`[Switch]`|false   |named   |false        |NoMandatoryParameters<br/>No Mandatory Parameters<br/>NoMandatories<br/>No Mandatories|

#### **OutputTypeName**
If provided, will decorate any outputs from the REST api with this typename.
If this is not provied, the URL will be used as the typename.

|Type      |Required|Position|PipelineInput|Aliases                                                                                             |
|----------|--------|--------|-------------|----------------------------------------------------------------------------------------------------|
|`[String]`|false   |named   |false        |Output Type Name<br/>Decorate<br/>PSTypeName<br/>PsuedoTypeName<br/>Psuedo Type<br/>Psuedo Type Name|

---

### Syntax
```PowerShell
Protocol.OpenAPI -SchemaUri <Uri> -ScriptBlock <ScriptBlock> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-AccessTokenParameter <String>] [-AccessTokenAlias <String[]>] [-NoMandatory] [-OutputTypeName <String>] [<CommonParameters>]
```
```PowerShell
Protocol.OpenAPI [-SchemaUri] <Uri> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-AccessTokenParameter <String>] [-AccessTokenAlias <String[]>] [-NoMandatory] [-OutputTypeName <String>] [<CommonParameters>]
```
```PowerShell
Protocol.OpenAPI [-SchemaUri] <Uri> -CommandAst <CommandAst> [-RemovePropertyPrefix <String[]>] [-ExcludeProperty <String[]>] [-IncludeProperty <String[]>] [-AccessTokenParameter <String>] [-AccessTokenAlias <String[]>] [-NoMandatory] [-OutputTypeName <String>] [<CommonParameters>]
```

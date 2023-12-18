Protocol.HTTP
-------------

### Synopsis
HTTP protocol

---

### Description

Converts an http(s) protocol commands to PowerShell.

---

### Examples
> EXAMPLE 1

```PowerShell
{
    https://api.github.com/repos/StartAutomating/PipeScript
}
```
> EXAMPLE 2

```PowerShell
{
    get https://api.github.com/repos/StartAutomating/PipeScript
} | .>PipeScript
```
> EXAMPLE 3

```PowerShell
Invoke-PipeScript {
    $GitHubApi = 'api.github.com'
    $UserName  = 'StartAutomating'
    https://$GitHubApi/users/$UserName
}
```
> EXAMPLE 4

```PowerShell
-ScriptBlock {
    https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
}
```
> EXAMPLE 5

```PowerShell
-ScriptBlock {
    https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
}
```
> EXAMPLE 6

```PowerShell
-ScriptBlock {
    @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
        $repo | .Name .Stars { $_.stargazers_count }
    }) | Sort-Object Stars -Descending
}
```
> EXAMPLE 7

```PowerShell
$semanticAnalysis = 
    Invoke-PipeScript {
        http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
            Select-Object -ExpandProperty Probability -Property Label
    }
$semanticAnalysis
```
> EXAMPLE 8

```PowerShell
$statusHealthCheck = {
    [Https('status.dev.azure.com/_apis/status/health')]
    param()
} | Use-PipeScript
& $StatusHealthCheck
```

---

### Parameters
#### **CommandUri**
The URI.

|Type   |Required|Position|PipelineInput|
|-------|--------|--------|-------------|
|`[Uri]`|true    |1       |false        |

#### **CommandAst**
The Command's Abstract Syntax Tree

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[CommandAst]`|true    |named   |false        |

#### **ScriptBlock**

|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|

#### **ArgumentList**
Any remaining arguments.  These will be passed positionally to the invoker.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |

#### **Parameter**
Any named parameters for the invoker.

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |

#### **Method**
The HTTP method.  By default, get.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **Invoker**
The invocation command.  By default, Invoke-RestMethod.
Whatever alternative command provided should have a similar signature to Invoke-RestMethod.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

---

### Syntax
```PowerShell
Protocol.HTTP [-CommandUri] <Uri> -ScriptBlock <ScriptBlock> [-ArgumentList <Object>] [-Parameter <IDictionary>] [-Method <String>] [-Invoker <String>] [<CommonParameters>]
```
```PowerShell
Protocol.HTTP [-CommandUri] <Uri> [-ArgumentList <Object>] [-Parameter <IDictionary>] [-Method <String>] [-Invoker <String>] [<CommonParameters>]
```
```PowerShell
Protocol.HTTP [-CommandUri] <Uri> -CommandAst <CommandAst> [-ArgumentList <Object>] [-Parameter <IDictionary>] [-Method <String>] [-Invoker <String>] [<CommonParameters>]
```

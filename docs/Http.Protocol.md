Http.Protocol
-------------
### Synopsis
http protocol

---
### Description

Converts an http[s] protocol command to PowerShell.

---
### Examples
#### EXAMPLE 1
```PowerShell
{
    https://api.github.com/repos/StartAutomating/PipeScript
}
```

#### EXAMPLE 2
```PowerShell
{
    get https://api.github.com/repos/StartAutomating/PipeScript
} | .>PipeScript
```

#### EXAMPLE 3
```PowerShell
Invoke-PipeScript {
    $GitHubApi = 'api.github.com'
    $UserName  = 'StartAutomating'
    https://$GitHubApi/users/$UserName
}
```

#### EXAMPLE 4
```PowerShell
-ScriptBlock {
    https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
}
```

#### EXAMPLE 5
```PowerShell
-ScriptBlock {
    https://$GitHubApi/users/$UserName -GitHubApi api.github.com -UserName StartAutomating
}
```

#### EXAMPLE 6
```PowerShell
-ScriptBlock {
    @(foreach ($repo in https://api.github.com/users/StartAutomating/repos?per_page=100) {
        $repo | .Name .Stars { $_.stargazers_count }
    }) | Sort-Object Stars -Descending
}
```

#### EXAMPLE 7
```PowerShell
{
    http://text-processing.com/api/sentiment/ -Method POST -ContentType 'application/x-www-form-urlencoded' -Body "text=amazing!" |
        Select-Object -ExpandProperty Probability -Property Label
}
```

---
### Parameters
#### **CommandUri**

The URI.






|Type   |Required|Position|PipelineInput |
|-------|--------|--------|--------------|
|`[Uri]`|true    |1       |true (ByValue)|



---
#### **CommandAst**

The Command's Abstract Syntax Tree






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[CommandAst]`|true    |2       |false        |



---
#### **Method**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |



---
### Syntax
```PowerShell
Http.Protocol [-CommandUri] <Uri> [-CommandAst] <CommandAst> [[-Method] <String>] [<CommonParameters>]
```
---


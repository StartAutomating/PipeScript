PipeScript.Protocol
-------------------

### Synopsis
Core Protocol Transpiler

---

### Description

Enables the transpilation of protocols.

```https://api.github.com/repos/StartAutomating/PipeScript/issues``` is a valid command.

So is ```get https://api.github.com/repos/StartAutomating/PipeScript/issues```.

So is ```MyCustomProtocol:// -Parameter value```.

This transpiler enables commands in protocol format to be transpiled.

---

### Examples
> EXAMPLE 1

```PowerShell
-ScriptBlock {
    https://api.github.com/users/StartAutomating
}
```
> EXAMPLE 2

```PowerShell
-ScriptBlock {
    $userName = 'StartAutomating'
    https://$GitHubApi/users/$UserName
}
```
> EXAMPLE 3

```PowerShell
-ScriptBlock {
    $env:GitUserName = 'StartAutomating'
    https://api.github.com/users/$env:GitUserName
}
```

---

### Parameters
#### **CommandAst**
The Command Abstract Syntax Tree.

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[CommandAst]`|true    |1       |true (ByValue)|

---

### Notes
This transpiler will match any command whose first or second element contains ```://```

---

### Syntax
```PowerShell
PipeScript.Protocol [-CommandAst] <CommandAst> [<CommonParameters>]
```

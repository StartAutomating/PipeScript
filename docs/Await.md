
Await
-----
### Synopsis
awaits asynchronous operations

---
### Description

awaits the result of a task.

---
### Examples
#### EXAMPLE 1
```PowerShell
PipeScript -ScriptBlock {
    await $Websocket.SendAsync($SendSegment, 'Binary', $true, [Threading.CancellationToken]::new($false))
}
```

#### EXAMPLE 2
```PowerShell
PipeScript -ScriptBlock {
    $receiveResult = await $Websocket.ReceiveAsync($receiveSegment, [Threading.CancellationToken]::new($false))
}
```

---
### Parameters
#### **CommandAst**

> **Type**: ```[CommandAst]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
### Syntax
```PowerShell
Await [-CommandAst] <CommandAst> [<CommonParameters>]
```
---




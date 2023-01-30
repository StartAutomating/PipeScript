UDP.Protocol
------------
### Synopsis
udp protocol

---
### Description

Converts a UDP protocol command to PowerShell

---
### Examples
#### EXAMPLE 1
```PowerShell
udp://127.0.0.1:8568  # Creates a UDP Client
```

#### EXAMPLE 2
```PowerShell
udp:// -Host [ipaddress]::broadcast -port 911 -Send "It's an emergency!"
```

#### EXAMPLE 3
```PowerShell
{send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"}.Transpile()
```

#### EXAMPLE 4
```PowerShell
Invoke-PipeScript { receive udp://*:911 }
```
Invoke-PipeScript { send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!" }

Invoke-PipeScript { receive udp://*:911 -Keep }
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
### Syntax
```PowerShell
UDP.Protocol [-CommandUri] <Uri> [-CommandAst] <CommandAst> [<CommonParameters>]
```
---


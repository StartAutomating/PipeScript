Protocol.UDP
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
{send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!"} | Use-PipeScript
```

#### EXAMPLE 4
```PowerShell
Invoke-PipeScript { watch udp://*:911 } 
Invoke-PipeScript { send udp:// -Host [ipaddress]::broadcast -Port 911 "It's an emergency!" }
Invoke-PipeScript { receive udp://*:911 }
```



---


### Parameters
#### **CommandUri**

The URI.






|Type   |Required|Position|PipelineInput|
|-------|--------|--------|-------------|
|`[Uri]`|true    |1       |false        |



#### **Method**

Valid Values:

* Send
* Receive
* Watch






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |



#### **CommandAst**

The Command's Abstract Syntax Tree






|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[CommandAst]`|true    |named   |false        |



#### **ScriptBlock**

If the UDP protocol is used as an attribute, this will be the existing script block.






|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[ScriptBlock]`|true    |named   |false        |



#### **Send**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |



#### **Receive**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |



#### **Watch**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Object]`|false   |named   |false        |



#### **HostName**




|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |named   |false        |Host   |



#### **Port**




|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |



#### **ArgumentList**




|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |





---


### Syntax
```PowerShell
Protocol.UDP [-CommandUri] <Uri> [[-Method] <String>] -ScriptBlock <ScriptBlock> [-Send <Object>] [-Receive <Object>] [-Watch <Object>] [-HostName <String>] [-Port <Int32>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Protocol.UDP [[-CommandUri] <Uri>] [[-Method] <String>] [-Send <Object>] [-Receive <Object>] [-Watch <Object>] [-HostName <String>] [-Port <Int32>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```
```PowerShell
Protocol.UDP [-CommandUri] <Uri> [[-Method] <String>] -CommandAst <CommandAst> [-Send <Object>] [-Receive <Object>] [-Watch <Object>] [-HostName <String>] [-Port <Int32>] [-ArgumentList <PSObject[]>] [<CommonParameters>]
```

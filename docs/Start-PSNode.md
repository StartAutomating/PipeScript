Start-PSNode
------------




### Synopsis
Starts a PSNode Job



---


### Description

Starts a PSNode Job.

This will run in the current context and allow you to run PowerShell or PipeScript as a



---


### Parameters
#### **Command**

The Script Block to run in the Job






|Type           |Required|Position|PipelineInput |Aliases               |
|---------------|--------|--------|--------------|----------------------|
|`[ScriptBlock]`|true    |1       |true (ByValue)|ScriptBlock<br/>Action|



#### **Server**

One or more listener prefixes that will be used to handle to request.






|Type        |Required|Position|PipelineInput|Aliases|
|------------|--------|--------|-------------|-------|
|`[String[]]`|false   |named   |false        |Route  |



#### **CORS**

The cross origin resource sharing






|Type      |Required|Position|PipelineInput|Aliases                                                 |
|----------|--------|--------|-------------|--------------------------------------------------------|
|`[String]`|false   |named   |false        |AccessControlAllowOrigin<br/>Access-Control-Allow-Origin|



#### **RootPath**

The root directory.  If this is provided, the PSNode will act as a file server for this location.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **BufferSize**

The buffer size.  If PSNode is acting as a file server, this is the size of the buffer that it will use to stream files.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt32]`|false   |named   |false        |



#### **PoolSize**

The number of runspaces in the PSNode's runspace pool.
As the PoolSize increases, the PSNode will be able to handle more concurrent requests and will consume more memory.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[UInt32]`|false   |named   |false        |



#### **SessionTimeout**

The user session timeout.  By default, 15 minutes.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |named   |false        |



#### **ImportModule**

The modules that will be loaded in the PSNode






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |named   |false        |



#### **AllowBrowseDirectory**

If set, will allow the directories beneath RootPath to be browsed.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **AllowScriptExecution**

If set, will execute .ps1 files located beneath the RootPath.  If this is not provided, these .PS1 files will be displayed in the browser like any other file (assuming you provided a RootPath)






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **Credential**




|Type            |Required|Position|PipelineInput|
|----------------|--------|--------|-------------|
|`[PSCredential]`|false   |named   |false        |



#### **AuthenticationType**

The authentication type



Valid Values:

* None
* Digest
* Negotiate
* Ntlm
* IntegratedWindowsAuthentication
* Basic
* Anonymous






|Type                     |Required|Position|PipelineInput        |
|-------------------------|--------|--------|---------------------|
|`[AuthenticationSchemes]`|false   |named   |true (ByPropertyName)|





---


### Syntax
```PowerShell
Start-PSNode [-Command] <ScriptBlock> [-Server <String[]>] [-CORS <String>] [-RootPath <String>] [-BufferSize <UInt32>] [-PoolSize <UInt32>] [-SessionTimeout <TimeSpan>] [-ImportModule <String[]>] [-AllowBrowseDirectory] [-AllowScriptExecution] [-Credential <PSCredential>] [-AuthenticationType {None | Digest | Negotiate | Ntlm | IntegratedWindowsAuthentication | Basic | Anonymous}] [<CommonParameters>]
```

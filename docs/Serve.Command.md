Serve.Command
-------------

### Synopsis
Serves a command.

---

### Description

Serves a command or pattern of commands.

---

### Parameters
#### **Command**
The command or pattern of commands that is being served.

|Type        |Required|Position|PipelineInput        |Aliases       |
|------------|--------|--------|---------------------|--------------|
|`[PSObject]`|true    |named   |true (ByPropertyName)|CommandPattern|

#### **Request**
The request object.
This should generally not be provided, as it will be provided by the server.
(it can be provided for testing purposes)

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|

#### **Parameter**
A collection of parameters to pass to the command.

|Type        |Required|Position|PipelineInput        |Aliases   |
|------------|--------|--------|---------------------|----------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|Parameters|

#### **DefaultParameter**
A collection of parameters to pass to the command by default, if no parameter was provided.

|Type        |Required|Position|PipelineInput        |Aliases          |
|------------|--------|--------|---------------------|-----------------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|DefaultParameters|

#### **RemoveParameter**
One or more parameters to remove.

|Type        |Required|Position|PipelineInput        |Aliases                                           |
|------------|--------|--------|---------------------|--------------------------------------------------|
|`[String[]]`|false   |named   |true (ByPropertyName)|HideParameter<br/>DenyParameter<br/>DenyParameters|

#### **Name**
The displayed name of the command

|Type      |Required|Position|PipelineInput        |Aliases              |
|----------|--------|--------|---------------------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|Title<br/>DisplayName|

---

### Syntax
```PowerShell
Serve.Command -Command <PSObject> [-Request <PSObject>] [-Parameter <PSObject>] [-DefaultParameter <PSObject>] [-RemoveParameter <String[]>] [-Name <String>] [<CommonParameters>]
```
